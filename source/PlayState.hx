package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import haxe.io.ArrayBufferView.ArrayBufferViewData;
import source.entitys.Populite;
import source.world.Container;
import source.world.Tree;
import source.Helper;
import source.world.Building;
import source.world.Resource.Res;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	
	public var population:FlxTypedGroup<Populite>;
	public var resources:FlxTypedGroup<Container>;
	public var buildings:FlxTypedGroup<Building>;
	
	public var SelectedName:FlxText;
	public var SelectedAge:FlxText;
	public var SelectedMale:FlxText;
	public var ResAmt:FlxText;
	public var FoodAmt:FlxText;
	public var days:Int;
	
	
	public var res:Map<EnumValue,Int>;
	var t:Int;
	/**
	 * Function that is called up when to state is created to set it up. 
	 * */
	override public function create():Void
	{
		super.create();
		
		population = new FlxTypedGroup<Populite>();
		add(population);
		
		resources = new FlxTypedGroup<Container>();
		add(resources);
		
		buildings = new FlxTypedGroup<Building>();
		add(buildings);
		
		SelectedName = new FlxText(10, 480 - 10 * 4);
		SelectedAge = new FlxText(10, 480 - 10 * 3);
		SelectedMale = new FlxText(10, 480 - 10 * 2);
		
		ResAmt = new FlxText(10, 10);
		FoodAmt = new FlxText(10, 20);
		
		add(SelectedAge);
		add(SelectedMale);
		add(SelectedName);
		add(FoodAmt);
		add(ResAmt);
		t = 1;
		res = new Map<EnumValue,Int>();
		addLife();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		if (t++ % (60 * 60) == 0) {
			days++;
			if (days % 5 == 0) {
				for (i in 0...population.members.length) population.members[i].ageInc();
			}
		}
		if (Helper.selectedPop == null) {
			SelectedAge.visible = false;
			SelectedName.visible = false;
			SelectedMale.visible = false;
		}else {
			SelectedAge.visible = true;
			SelectedName.visible = true;
			SelectedMale.visible = true;
			
			SelectedAge.text = Helper.selectedPop.data.get("Age");
			SelectedName.text = Helper.selectedPop.data.get("Name");
			SelectedMale.text = Helper.selectedPop.data.get("Male") == "true"?"Male":"Female";
		}
		
		if (FlxG.mouse.pressedRight && Helper.selectedPop != null) {	
			for (i in 0...resources.length) {
				var s:Container = resources.members[i];
				if(FlxG.mouse.x >= s.x && FlxG.mouse.y >= s.y && FlxG.mouse.x <= s.x + s.width && FlxG.mouse.y <= s.y + s.height ){
					if (Std.is(s, Tree)) {
						Helper.selectedPop.currentTask = AvalibleTasks.gatherResr;
						Helper.selectedPop.targetLocation = s;
						Helper.selectedPop = null;
					}
				}
			}
		}
		updateCounters();
	}	
	
	public function addPop(?x:Int = 1):Void {
		for (i in 0...x) population.add(new Populite(Math.floor(Math.random() * 640), Math.floor(Math.random() * 480)));
	}
	
	public function addLife():Void {
		for (i in 0...5) resources.add(new Tree(Math.floor(Math.random() * 640), Math.floor(Math.random() * 480)));
		addPop(15);
		days = 0;
		
		addBuilding(50, 50);
	}
	
	public function addBuilding(x:Float, y:Float):Void {
		for (i in 0...resources.length) {
			var d:Container = resources.members[i];
			if (d.x - 10 > x && d.y - 10 > y && d.x + 64 + 10 < x && d.y + 64 + 10 < y) {
				addResources(d.drop.type, d.drop.value);
			}
		}
		buildings.add(new Building(50, 50));
	}
	
	public function addResources(type:EnumValue, val:Int) { 	
		if (!res.exists(type)) res.arrayWrite(type, val);
		else res.set(type, res.get(type)+val);
	}
	
	public function updateCounters():Void {
		FoodAmt.text = "Food: " + (res.exists(Res.food)?"" + res.get(Res.food):"0");
		ResAmt.text = "Res: " + (res.exists(Res.wood)?"" + res.get(Res.wood):"0");
	}
}