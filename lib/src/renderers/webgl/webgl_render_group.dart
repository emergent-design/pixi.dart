part of pixi;


class WebGLRenderGroup
{
	GL.RenderingContext _context	= null;
	DisplayObjectContainer _root	= null;
	Colour backgroundColor			= new Colour(0, 0, 0);
	List<DisplayObject> _batches	= [];
	// toRemove = [] ??
	// filterManager


	WebGLRenderGroup(this._context);


	void setRenderable(DisplayObjectContainer object)
	{
		if (this._root != null) this._removeDisplayObjectAndChildren(this._root);

		//object.worldVisible = object.visible;

		this._root = object;
		this._addDisplayObjectAndChildren(object);
	}


	void render(GL.RenderingContext gl, Point projection, Point offset)
	{
		// parent updateTextures()??
		//gl.useProgram(WebGLShaders.currentShader.program);
		gl.uniform2f(WebGLShaders.currentShader.projectionVector, projection.x, projection.y);

		//this.filterManager.begin(projection, buffer);

		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);

		for (var batch in this._batches)
		{
			if (batch is WebGLBatch)	batch.render(gl);
			else 						this._renderSpecial(gl, batch, projection, offset);
		}
	}


	void _renderSpecial(GL.RenderingContext gl, DisplayObject object, Point projection, Point offset)
	{
		//var sta = PIXI.shaderStack.length;
		var worldVisible = object._vcount == DisplayObject._visibleCount;

		if (object is Graphics)
		{
			if (worldVisible && object.renderable) WebGLGraphics.renderGraphics(gl, object, projection, offset);
			//if (worldVisible)??
			//if (batch.renderable) WebGLGraphics.renderGraphics(gl, batch, projection);
		}
		//else if (object is Strip)
		//{
		//	if(worldVisible) this.renderStrip(renderable, projection);
		//}
		//else if (object is TilingSprite)
		//{
		//	if(worldVisible) this.renderTilingSprite(renderable, projection);
		//}
		//else if (object is FilterBlock)
		//{
		//	this._renderFilterBlock(gl, object, projection);
		//}
	}


	//void _renderSpecific(displayObject, projection, buffer)
	//{
	//}


	void _addDisplayObjectAndChildren(DisplayObject object)
	{
		if (object.__group != null) object.__group._removeDisplayObjectAndChildren(object);

		var end			= this._root._childList;
		var previous 	= object._previous;
		while (previous != end && !(previous._renderable && previous.__group != null))
		{
			previous = previous._previous;
		}

		var next = object is DisplayObjectContainer ? object.getLast._next : object._next;
		while (next != end && !(next._renderable && next.__group != null))
		{
			next = next._next;
		}

		var temp = object;
		var last = object is DisplayObjectContainer ? object.getLast._next : object._next;

		while (temp != last)
		{
			temp.__group = this;

			if (temp._renderable)
			{
				this._insertObject(temp, previous == end ? null : previous, next == end ? null : next);
				previous = temp;
			}

			temp = temp._next;
		}
	}


	void _removeDisplayObjectAndChildren(DisplayObject object)
	{
		if (object.__group != this) return;

		var last = object is DisplayObjectContainer ? object.children.last._next : object._next;

		while (object != last)
		{
			object.__group = null;
			if (object._renderable) this._removeObject(object);
			object = object._next;
		}
	}


	void _insertObject(DisplayObject object, DisplayObject previous, DisplayObject next)
	{
		var previousSprite	= previous;
		var nextSprite		= next;

		if (object is Sprite)
		{
			DisplayObject previousBatch	= null;
			DisplayObject nextBatch		= null;

			if (previousSprite is Sprite)
			{
				previousBatch = previousSprite.__batch;
				var batch = previousSprite.__batch;

				if (batch != null)
				{
					if (batch._texture == object._texture._base && batch._blendMode == object.blendMode)
					{
						batch.addAfter(new _SpriteLink(object), previousSprite.__link);
						return;
					}
					else previousBatch = batch;
				}
			}
			else previousBatch = previousSprite;

			if (nextSprite != null)
			{
				if (nextSprite is Sprite)
				{
					var batch = nextSprite.__batch;

					if (batch != null)
					{
						if (batch._texture == object._texture._base && batch._blendMode == object.blendMode)
						{
							batch.addBefore(new _SpriteLink(object), nextSprite.__link);
							return;
						}
						else
						{
							if (batch == previousBatch)
							{
								var split 	= (previousBatch as WebGLBatch).split(nextSprite.__link);
								var b		= WebGLBatch._getBatch(this._context);
								var index	= this._batches.indexOf(previousBatch);

								b.init(new _SpriteLink(object));
								this._batches.insertAll(index + 1, [b, split]);

								return;
							}
						}

						nextBatch = batch;
					}
				}
				else nextBatch = nextSprite;
			}

			var batch = WebGLBatch._getBatch(this._context);
			batch.init(new _SpriteLink(object));

			if (previousBatch != null)
			{
				this._batches.insert(this._batches.indexOf(previousBatch) + 1, batch);
			}
			else
			{
				this._batches.add(batch);
			}

			return;
		}
		//else if (object is TilingSprite)
		//else if (object is Strip)


		this._insertAfter(object, previousSprite);
	}


	void _insertAfter(DisplayObject object, DisplayObject previous)
	{
		if (previous is Sprite)
		{
			var batch = previous.__batch;

			if (batch != null)
			{
				if (batch._sprites.last == previous.__link)
				{
					// Previous sprite is the last in a batch so
					// safe to add the object after.
					this._batches.insert(this._batches.indexOf(batch), object);
				}
				else
				{
					// Previous sprite is in the middle of a batch
					// so the batch needs to be split.

					var split = batch.split(previous.__link._next);
					var index = this._batches.indexOf(batch);

					this._batches.insertAll(index + 1, [ object, split ]);
				}
			}
			else this._batches.add(object);
		}
		else
		{
			if (previous != null)
			{
				this._batches.insert(this._batches.indexOf(previous) + 1, object);
			}
			else this._batches.insert(0, object);
		}
	}


	void _removeObject(DisplayObject object)
	{
		WebGLBatch toRemove = null;

		if (object is Sprite)
		{
			var batch = object.__batch;

			// This means the display list has been altered before rendering
			if (batch == null) return;

			batch.remove(object.__link);
			object.__link.src = null;

			if (batch.size == 0) toRemove = batch;
		}
		else toRemove = object;


		if (toRemove != null)
		{
			var index = this._batches.indexOf(toRemove);

			// This means it was added then removed before rendering
			if (index == -1) return;

			if (index == 0 || index == this._batches.length - 1)
			{
				this._batches.removeAt(index);

				if (toRemove is WebGLBatch) WebGLBatch._returnBatch(toRemove);

				return;
			}

			var before 	= this._batches[index - 1];
			var after	= this._batches[index + 1];

			if (before is WebGLBatch && after is WebGLBatch)
			{
				if (before._texture == after._texture && before._blendMode == after._blendMode)
				{
					before.merge(after);

					if (toRemove is WebGLBatch) WebGLBatch._returnBatch(toRemove);
					WebGLBatch._returnBatch(after);

					this._batches.removeRange(index, index+2);

					return;
				}
			}

			this._batches.removeAt(index);

			if (toRemove is WebGLBatch) WebGLBatch._returnBatch(toRemove);
		}
	}



	/*void _renderFilterBlock(RenderingContext gl, FilterBlock filter, Point projection)
	{
		/*
		 * for now only masks are supported..
		 */
		var gl = PIXI.gl;

		if(filterBlock.open)
		{
			if(filterBlock.data instanceof Array)
			{
				//var filter = filterBlock.data[0];
				//console.log(filter)
				this.filterManager.pushFilter(filterBlock);//filter);
				// ok so..

			}
			else
			{

				gl.enable(gl.STENCIL_TEST);

				gl.colorMask(false, false, false, false);
				gl.stencilFunc(gl.ALWAYS,1,0xff);
				gl.stencilOp(gl.KEEP,gl.KEEP,gl.REPLACE);
				PIXI.WebGLGraphics.renderGraphics(filterBlock.data, projection);

				gl.colorMask(true, true, true, true);
				gl.stencilFunc(gl.NOTEQUAL,0,0xff);
				gl.stencilOp(gl.KEEP,gl.KEEP,gl.KEEP);
			}
		}
		else
		{
			if(filterBlock.data instanceof Array)
			{
				this.filterManager.popFilter();
			//	PIXI.popShader();
			//	gl.uniform2f(PIXI.currentShader.projectionVector, projection.x, projection.y);
			}
			else
			{
				gl.disable(gl.STENCIL_TEST);
			}
		}
	}*/


	void _updateTexture(Sprite sprite)
	{
		this._removeObject(sprite);

		var end			= this._root._childList;
		var previous 	= sprite._previous;
		while (previous != end && !(previous._renderable && previous.__group != null))
		{
			previous = previous._previous;
		}

		var next = sprite._next;
		while (next != end && !(next._renderable && next.__group != null))
		{
			next = next._next;
		}

		this._insertObject(sprite, previous, next);
	}

	//void addFilterBlocks
	//void removeFilterBlocks

}

