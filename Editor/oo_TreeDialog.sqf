#include "..\oop.h"
CLASS("oo_TreeDialog")
	PUBLIC UI_VARIABLE("control", "Control");
	PUBLIC VARIABLE("code", "this");
	PUBLIC VARIABLE("script", "handle");
	
	PUBLIC FUNCTION("","constructor") { 
		MEMBER("Control", controlNull);
		MEMBER("handle", scriptNull);	
	};

	PUBLIC FUNCTION("","show") {
		disableSerialization;
		if!(MEMBER("Control", nil) isEqualTo controlNull) exitWith {
			if (scriptDone MEMBER("handle", nil)) then {
				private _handle = SPAWN_MEMBER("hide", nil);
				MEMBER("handle", _handle);
			};
		};
		private _tree = ("getDisplay" call GuiObject) ctrlCreate["OOP_Tree",-2];
		MEMBER("Control", _tree);
		_tree ctrlSetPosition [safezoneX,safezoneY, safezoneW/5, safezoneH];
		_tree ctrlCommit 0;
		MEMBER("fill", nil);
		_tree ctrlAddEventHandler ["TreeSelChanged", format["['TreeSelChanged', _this] spawn %1", MEMBER("this", nil)]];
		_tree ctrlAddEventHandler ["TreeDblClick", format["['TreeDblClick', _this] spawn %1", MEMBER("this", nil)]];
	};

	PUBLIC FUNCTION("","hide") {
		disableSerialization;
		if (MEMBER("Control", nil) isEqualTo controlNull) exitWith {};
		private _tree = MEMBER("Control", nil);
		private _helperStyle = ["new", "getDisplay" call GuiObject] call oo_HelperStyle;
		["close", [_tree, 0.2, "left"]] call _helperStyle;
		sleep 0.2;
		ctrlDelete _tree;
		MEMBER("Control", controlNull);
	};

	PUBLIC FUNCTION("array","fill") {
		MEMBER("fill", nil);
		MEMBER("Control", nil) tvSetCurSel _this;
	};

	PUBLIC FUNCTION("","fill") {
		disableSerialization;
		private _control = MEMBER("Control", nil);
		if (_control isEqualTo controlNull) exitWith {};
		tvClear _control;
		["addInTree", [_control, []]] call ("getView" call GuiObject);
	};

	PUBLIC FUNCTION("array","TreeDblClick") {
		disableSerialization;
		private _item = call compile ((_this select 0) tvData (_this select 1));
		if ("getTypeName" call _item isEqualTo "oo_Layer") exitWith {
			if!("isVisible" call _item) exitWith {};
			["setActiveLayer", _item] call GuiObject;
		};
		["setActiveLayer", ("getParentLayer" call _item)] call GuiObject;
		["setSelCtrl", _item] call GuiObject;
		createDialog "ctrlModifyDialog";
	};

	PUBLIC FUNCTION("","getCurlSel") {
		disableSerialization;

		private _item = call compile (MEMBER("Control", nil) tvData (tvCurSel MEMBER("Control", nil)));
		_item;
	};

	PUBLIC FUNCTION("array","TreeSelChanged") {
		disableSerialization;
		private _item = call compile ((_this select 0) tvData (_this select 1));
		if (isNil {_item}) exitWith {};
		if (_item isEqualTo ("getView" call GuiObject)) exitWith {};
		["setSelCtrl", _item] call GuiObject;
		"colorize" call _item;
	};

	PUBLIC FUNCTION("","isOpen") {
		if!(MEMBER("Control", nil) isEqualTo controlNull) exitWith {
			true;
		};
		false;
	};

	PUBLIC FUNCTION("","getPath") {
		tvCurSel MEMBER("Control", nil);
	};

	PUBLIC FUNCTION("","getSel") {
		private _control = MEMBER("Control", nil);
		private _path = tvCurSel _control;
		private _item = call compile (_control tvData _path);
		if (_item isEqualTo ("getView" call GuiObject)) exitWith {{}};
		_item;
	};

	PUBLIC FUNCTION("","getControl") {
		MEMBER("Control", nil);
	};
ENDCLASS;	