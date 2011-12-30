﻿import gfx.events.EventDispatcher;

class skyui.ItemTypeFilter implements skyui.IFilter
{
	private var _itemFilter;
	private var _filterArray:Array;

	private var entryMatchesFunc:Function;

	//Mixin
	var dispatchEvent:Function;
	var addEventListener:Function;

	static var DEBUG_LEVEL = 1;

	function ItemTypeFilter()
	{
		_itemFilter = 4294967295;
		entryMatchesFunc = entryMatchesFilter;
		EventDispatcher.initialize(this);
	}


	function get itemFilter()
	{
		return _itemFilter;
	}

	function set itemFilter(a_newFilter)
	{
		var changed = _itemFilter != a_newFilter;
		_itemFilter = a_newFilter;

		if (changed == true)
		{
			dispatchEvent({type:"filterChange"});
		}
	}

	function setPartitionedFilterMode(a_bPartition)
	{
		if (DEBUG_LEVEL > 0)
			_global.skse.Log("ItemTypeFilter setPartitionFilterMode()");
		entryMatchesFunc = a_bPartition ? entryMatchesPartitionedFilter : entryMatchesFilter;
	}

/*
	filterFlag = 0 , removes the entry from array
	filterFlag = 1, ignores entry and keeps it in array

*/
	function entryMatchesFilter(a_entry)
	{
		if (DEBUG_LEVEL > 1)
			_global.skse.Log("ItemTypeFilter entryMatchesFilter()");
		//_global.skse.Log("entry = " + a_entry.text + ", filterFlag = " + a_entry.filterFlag + ", _itemFilter = " + _itemFilter + ", flag = " + a_entry.flag);
		return (a_entry != undefined && (a_entry.filterFlag == undefined || (a_entry.filterFlag & _itemFilter) != 0));
	}

	function entryMatchesPartitionedFilter(a_entry)
	{
		if (DEBUG_LEVEL > 1)
			_global.skse.Log("ItemTypeFilter entryMatchesPartitionedFilter()");
		var _loc3 = false;
		if (a_entry != undefined)
		{
			if (_itemFilter == 4294967295)
			{
				_loc3 = true;
			}
			else
			{
				var _loc2 = a_entry.filterFlag;
				var _loc4 = _loc2 & 255;
				var _loc7 = (_loc2 & 65280) >>> 8;
				var _loc6 = (_loc2 & 16711680) >>> 16;
				var _loc5 = (_loc2 & 4278190080) >>> 24;
				_loc3 = _loc4 == _itemFilter || _loc7 == _itemFilter || _loc6 == _itemFilter || _loc5 == _itemFilter;
			}
		}
		return (_loc3);
	}

	function process(a_filteredList:Array)
	{
		if (DEBUG_LEVEL > 0)
			_global.skse.Log("ItemTypeFilter process()");
		for (var i = 0; i < a_filteredList.length; i++)
		{
			if (!entryMatchesFunc(a_filteredList[i]))
			{
				_global.skse.Log("Filtering out " + a_filteredList[i].text);
				a_filteredList.splice(i,1);
				i--;
			}
		}
	}
}