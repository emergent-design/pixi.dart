part of pixi;


// Mostly a copy of LinkedList<E> but since that cannot be extended
// to provide the split and merge functionality it has to be duplicated
// here.
class PixiList<E extends PixiListEntry<E>> extends IterableBase<E> implements _PixiListLink
{
	int _modificationCount = 0;
	int _length = 0;
	_PixiListLink _next;
	_PixiListLink _previous;

	/**
	 * Construct a new empty linked list.
	 */
	PixiList() {
		_next = _previous = this;
	}

	/**
	 * Add [entry] to the beginning of the list.
	 */
	void addFirst(E entry) {
		_insertAfter(this, entry);
	}

	/**
	 * Add [entry] to the end of the list.
	 */
	void add(E entry) {
		_insertAfter(_previous, entry);
	}

	/**
	 * Add [entries] to the end of the list.
	 */
	void addAll(Iterable<E> entries) {
		entries.forEach((entry) => _insertAfter(_previous, entry));
	}

	/**
	 * Remove [entry] from the list. This is the same as calling `entry.unlink()`.
	*
	 * If [entry] is not in the list, `false` is returned.
	 */
	bool remove(E entry) {
		if (entry._list != this) return false;
		_unlink(entry);  // Unlink will decrement length.
		return true;
	}

	Iterator<E> get iterator => new _PixiListIterator<E>(this);

	// TODO(zarah) Remove this, and let it be inherited by IterableMixin
	//String toString() => IterableMixinWorkaround.toStringIterable(this, '{', '}');

	int get length => _length;

	void clear() {
		_modificationCount++;
		_PixiListLink next = _next;
		while (!identical(next, this)) {
			E entry = next;
			next = entry._next;
			entry._next = entry._previous = entry._list = null;
		}
		_next = _previous = this;
		_length = 0;
	}

	E get first {
		if (identical(_next, this)) {
			throw new StateError('No such element');
		}
		return _next;
	}

	E get last {
		if (identical(_previous, this)) {
			throw new StateError('No such element');
		}
		return _previous;
	}

	E get single {
		if (identical(_previous, this)) {
			throw new StateError('No such element');
		}
		if (!identical(_previous, _next)) {
			throw new StateError('Too many elements');
		}
		return _next;
	}

	/**
	 * Call [action] with each entry in the list.
	*
	 * It's an error if [action] modify the list.
	 */
	void forEach(void action(E entry)) {
		int modificationCount = _modificationCount;
		_PixiListLink current = _next;
		while (!identical(current, this)) {
			action(current);
			if (modificationCount != _modificationCount) {
				throw new ConcurrentModificationError(this);
			}
			current = current._next;
		}
	}

	bool get isEmpty => _length == 0;

	void _insertAfter(_PixiListLink entry, E newEntry) {
		if (newEntry.list != null) {
			throw new StateError(
			'LinkedListEntry is already in a LinkedList');
		}
		_modificationCount++;
		newEntry._list = this;
		var predecessor = entry;
		var successor = entry._next;
		successor._previous = newEntry;
		newEntry._previous = predecessor;
		newEntry._next = successor;
		predecessor._next = newEntry;
		_length++;
	}

	void _unlink(PixiListEntry<E> entry) {
		_modificationCount++;
		entry._next._previous = entry._previous;
		entry._previous._next = entry._next;
		_length--;
		entry._list = entry._next = entry._previous = null;
	}


	// My additions
	PixiList<E> split(E splitPoint)
	{
		if (splitPoint._list != this)
		{
			throw new StateError("Entry is not a member of this list");
		}

		_modificationCount++;

		var result				= new PixiList<E>();
		result._previous		= _previous;
		result._next			= splitPoint;
		_previous				= splitPoint._previous;
		_previous._next			= this;
		splitPoint._previous	= result;
		result._previous._next	= result;

		result._updateLength();
		this._updateLength();

		return result;
	}


	// Removes a section of list
	PixiList<E> removeList(E start, E end)
	{
		if (start._list != this || end._list != this)
		{
			throw new StateError("The start or end entry point is not a member of this list");
		}

		_modificationCount++;

		var result				= new PixiList<E>();
		result._next			= start;
		result._previous		= end;
		start._previous._next	= end._next;
		end._next._previous		= start._previous;
		start._previous			= result;
		end._next				= result;

		result._updateLength();
		this._updateLength();

		return result;
	}


	void _updateLength()
	{
		var next	= _next;
		_length		= 0;

		while (!identical(next, this))
		{
			// Update the list reference in case this is the result
			// of splitting.
			next._list 	= this;
			next 		= next._next;
			_length++;
		}
	}


	void merge(PixiList<E> list)
	{
		_modificationCount++;
		list._modificationCount++;

		list._next._previous	= _previous;
		_previous._next 		= list._next;
		_previous				= list._previous;
		_previous._next			= this;
		_length += list._length;

		list._next = list._previous = list;
		list._length = 0;

		var next = _next;
		while (!identical(next, this))
		{
			next._list = this;
			next = next._next;
		}
	}


	void _insertListAfter(PixiList<E> list, E entry)
	{
		if (entry._list != this)
		{
			throw new StateError("Entry is not a member of this list");
		}

		_modificationCount++;
		list._modificationCount++;

		var next				= entry._next;
		list._next._previous 	= entry;
		entry._next				= list._next;
		list._previous._next	= next;
		next._previous			= list._previous;
		_length += list._length;

		list._next = list._previous = list;
		list._length = 0;

		next = _next;
		while (!identical(next, this))
		{
			next._list = this;
			next = next._next;
		}
	}
}


class _PixiListIterator<E extends PixiListEntry<E>> implements Iterator<E> {
	final PixiList<E> _list;
	final int _modificationCount;
	E _current;
	_PixiListLink _next;

	_PixiListIterator(PixiList<E> list)
		: _list = list,
		  _modificationCount = list._modificationCount,
		  _next = list._next;

	E get current => _current;

	bool moveNext() {
	  if (identical(_next, _list)) {
	    _current = null;
	    return false;
	  }
	  if (_modificationCount != _list._modificationCount) {
	    throw new ConcurrentModificationError(this);
	  }
	  _current = _next;
	  _next = _next._next;
	  return true;
	}
}


class _PixiListLink
{
	_PixiListLink _next;
	_PixiListLink _previous;
}


abstract class PixiListEntry<E extends PixiListEntry<E>> implements _PixiListLink
{
	PixiList<E> _list;
	_PixiListLink _next;
	_PixiListLink _previous;

	/**
	 * Get the list containing this element.
	 */
	PixiList<E> get list => _list;

	/**
	 * Unlink the element from the list.
	 */
	void unlink() {
		_list._unlink(this);
	}

	/**
	 * Return the succeeding element in the list.
	 */
	E get next {
		if (identical(_next, _list)) return null;
		return _next as E;
	}

	/**
	 * Return the preceeding element in the list.
	 */
	E get previous {
		if (identical(_previous, _list)) return null;
		return _previous as E;
	}

	/**
	 * insert an element after this.
	 */
	void insertAfter(E entry) {
		_list._insertAfter(this, entry);
	}

	/**
	 * Insert an element before this.
	 */
	void insertBefore(E entry) {
		_list._insertAfter(_previous, entry);
	}

	// Insert a list after this
	void insertListAfter(PixiList<E> list) {
		_list._insertListAfter(list, this);
	}
}

