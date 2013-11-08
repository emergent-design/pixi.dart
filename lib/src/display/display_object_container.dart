part of pixi;


class DisplayObjectContainer extends DisplayObject
{
	List<DisplayObject> _children = [];
	List<DisplayObject> get children => this._children;

	// Linked list containing the flattened scenegraph (local to this container).
	// When this container is added to another (such as the stage) this list will become
	// empty and the parent container linked list will own the link elements. When this
	// container is removed it will resume ownership of the link elements here.
	// It is named _childList because a DisplayObject is a link element and therefore
	// contains a reference to the parent via _list.
	//PixiList<DisplayObject> _childList = new PixiList<DisplayObject>();


	// Get the very last item (including any children) that belongs to this container
	// If there are no children then it returns itself
	DisplayObject get getLast => this._children.isEmpty ? this : this._children.last.getLast;


	DisplayObjectContainer()
	{
		//this._childList.add(this);
	}


	void _render(Renderer renderer)
	{
		for (var c in this._children) c._render(renderer);
	}


	void addChild(DisplayObject child)
	{
		if (child.parent != null) child.parent.removeChild(child);

		child._parent = this;

		/*if (this._stage != null)
		{
			child._setStage(this._stage);
		}

		// Add to the linked list
		if (child is DisplayObjectContainer)
		{
			this.getLast.insertListAfter(child._childList);
			//if (this._children.isEmpty) this.insertListAfter(child._childList);
			//else						this._children.last.insertListAfter(child._childList);
		}
		else this.getLast.insertAfter(child);
		//else if (this._children.isEmpty)	this.insertAfter(child);
		//else								this._children.last.insertAfter(child);*/

		this._children.add(child);

		/*if (this.__group != null)
		{
			if (child.__group != null) child.__group._removeDisplayObjectAndChildren(child);
			this.__group._addDisplayObjectAndChildren(child);
		}*/
	}


	void removeChild(DisplayObject child)
	{
		if (child._parent != this)
		{
			throw "Child does not belong to this container";
		}

		child._parent = null;
		/*child._setStage(null);

		// Remove from the linked list
		if (child is DisplayObjectContainer)
		{
			if (child.children.isEmpty) child._childList = this._list.removeList(child, child);
			else						child._childList = this._list.removeList(child, child._children.last);
		}
		else child.unlink();*/

		this._children.remove(child);

		/*if(child.__group != null)
		{
			child.__group._removeDisplayObjectAndChildren(child);
		}*/
	}


	void removeChildren()
	{
		for (var c in this._children) c.parent = null;
		this._children.clear();
	}


	void swapChildren(DisplayObject childA, DisplayObject childB)
	{
	}


	DisplayObject getChildAt(int index)
	{
		if (index >= 0 && index < this._children.length)
		{
			return this._children[index];
		}

		return null;
	}


	void updateTransform()
	{
		if (!this.visible) return;

		super.updateTransform();

		for (var c in this._children) c.updateTransform();
	}


	/*void _setStage(Stage stage)
	{
		super._setStage(stage);
		for (var c in this._children) c._setStage(stage);
	}*/
}
