part of pixi;


class DisplayObjectContainer extends DisplayObject
{
	List<DisplayObject> _children = [];
	List<DisplayObject> get children => this._children;


	void addChild(DisplayObject child)
	{
		if (child.parent != null) child.parent.removeChild(child);

		child._parent = this;

		this._children.add(child);

		if (this._stage != null)
		{

		}
	}


	void removeChild(DisplayObject child)
	{
		child._parent = null;
		this._children.remove(child);
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
}

/*
if(child.parent != undefined)
{

//// COULD BE THIS???
child.parent.removeChild(child);
//	return;
}

child.parent = this;

this.children.push(child);

// update the stage refference..

if(this.stage)
{
var tmpChild = child;
do
{
if(tmpChild.interactive)this.stage.dirty = true;
tmpChild.stage = this.stage;
tmpChild = tmpChild._iNext;
}
while(tmpChild)
}

// LINKED LIST //

// modify the list..
var childFirst = child.first
var childLast = child.last;
var nextObject;
var previousObject;

// this could be wrong if there is a filter??
if(this.filter)
{
previousObject =  this.last._iPrev;
}
else
{
previousObject = this.last;
}

nextObject = previousObject._iNext;

// always true in this case
// need to make sure the parents last is updated too
var updateLast = this;
var prevLast = previousObject;

while(updateLast)
{
if(updateLast.last == prevLast)
{
updateLast.last = child.last;
}
updateLast = updateLast.parent;
}

if(nextObject)
{
nextObject._iPrev = childLast;
childLast._iNext = nextObject;
}

childFirst._iPrev = previousObject;
previousObject._iNext = childFirst;

// need to remove any render groups..
if(this.__renderGroup)
{
// being used by a renderTexture.. if it exists then it must be from a render texture;
if(child.__renderGroup)child.__renderGroup.removeDisplayObjectAndChildren(child);
// add them to the new render group..
this.__renderGroup.addDisplayObjectAndChildren(child);
}
*/