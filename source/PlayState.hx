package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import haxe.io.ArrayBufferView.ArrayBufferViewData;
import source.effects.Smoke;
import source.entitys.Arrow;
import source.entitys.Populite;
import source.entitys.Ship;
import source.gui.Button;
import source.world.Container;
import source.world.Tree;
import source.Helper;
import source.world.Building;
import source.world.Resource.Res;
import flixel.util.FlxSort;
import source.world.buildings.Store;
import gui.GUI;
import haxe.Constraints.Function;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	
	public var population:FlxTypedGroup<Populite>;
	public var resources:FlxTypedGroup<Container>;
	public var buildings:FlxTypedGroup<Building>;
	public var gui:FlxTypedGroup<GUI>;
	public var SelectedName:FlxText;
	public var SelectedAge:FlxText;
	public var SelectedMale:FlxText;
	public var ResAmt:FlxText;
	public var FoodAmt:FlxText;
	public var days:Int;
	
	private var sh:Ship;
	private var ar:Arrow;
	private var mouseClick:Function;
	public var res:Map<EnumValue,Int>;
	var t:Int;
	/**
	 * Function that is called up when to state is created to set it up. 
	 * */
	override public function create():Void
	{
		super.create();
		
		FlxG.camera.bgColor = 0xFFF7D645;
		population = new FlxTypedGroup<Populite>();
		add(population);
		
		resources = new FlxTypedGroup<Container>();
		add(resources);
		
		buildings = new FlxTypedGroup<Building>();
		add(buildings);
		
		gui = new FlxTypedGroup<GUI>();
		gui.add(new Button(640/2 - 45/2,480 - 55,gui.length));
		
		SelectedName = new FlxText(10, 480 - 10 * 4);
		SelectedAge = new FlxText(10, 480 - 10 * 3);
		SelectedMale = new FlxText(10, 480 - 10 * 2);
		
		ResAmt = new FlxText(10, 10);
		FoodAmt = new FlxText(10, 20);
		sh = new Ship();
		add(sh);
		ar = new Arrow();
		add(ar);
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
			FlxG.log.add(days);
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
						break;
					}
				}
			}
		}
		
		if (FlxG.mouse.justPressed) {
			for (i in 0...population.length) {
				var c:Populite = population.members[i];
				if ((FlxG.mouse.x >= c.x && FlxG.mouse.y >= c.y && FlxG.mouse.x  <= c.x + c.width && FlxG.mouse.y  <= c.y + c.height)) {
					Helper.selectedPop = c;
					break;
				}
				Helper.selectedPop = null;
			}
		}
		
		for (i in 0...gui.length) {
			var g:GUI = gui.members[i];	
			if ((FlxG.mouse.x >= g.x && FlxG.mouse.y >= g.y && FlxG.mouse.x <= g.x + g.width && FlxG.mouse.y <= g.y + g.height) && FlxG.mouse.justPressed) {
				if (g.ID == 1) mouseClick = plant;
			}
		}
		population.sort(FlxSort.byY);
		if (!sh.alive) {
			shipFinish();
			sh.alive = true;
			sh.destroy();
		}
		updateCounters();
	}	
	
	public function addPop(?x:Int = 1):Void {
		for (i in 0...x) population.add(new Populite(Math.floor(Math.random() * 640), flash.Lib.current.stage.height - 100));
	}
	
	public function addLife():Void {
		for (i in 0...5) resources.add(new Tree(Math.floor(Math.random() * 640), Math.floor(Math.random() * 480)));
		days = 0;
		resources.sort(FlxSort.byY);
		addBuilding(50, 50);
	}
	
	public function addBuilding(x:Float, y:Float):Void {
		buildings.add(new Store(50, 50));
		for (i in 0...resources.length) {
			var d:Container = resources.members[i];
			if (d.x - 10 > x && d.y - 10 > y && d.x + 64 + 10 < x && d.y + 64 + 10 < y) {
				addResources(d.drop.type, d.drop.value);
			}
		}
	}
	
	public function addResources(type:EnumValue, val:Int, ?over:Bool = false) { 	
		if(!over){
			if (!res.exists(type)) res.arrayWrite(type, val);
			else res.set(type, res.get(type) + val);
		}else {
			if (!res.exists(type)) res.arrayWrite(type, val);
			else res.set(type, val);
		}
	}
	
	public function updateCounters():Void {
		res.set(Res.wood, 0);
		res.set(Res.food, 0);
		for (i in 0...buildings.length) {
			var b:Building = buildings.members[i];
			addResources(Res.food, b.getAmountOfSpecific(Res.food));
			addResources(Res.wood, b.getAmountOfSpecific(Res.wood));
		}
		FoodAmt.text = "Food: " + (res.exists(Res.food)?"" + res.get(Res.food):"0");
		ResAmt.text = "Res: " + (res.exists(Res.wood)?"" + res.get(Res.wood):"0");
	}
	
	public function shipFinish():Void {	
		add(SelectedAge);
		add(SelectedMale);
		add(SelectedName);
		add(FoodAmt);
		add(ResAmt);
		//addPop(15);
		
		var a:Populite = new Populite(sh.x + Math.floor(Math.random() * sh.width),sh.y + sh.height - 10);
		a.setGender(true);
		a.setAge(25);
		population.add(a);
		var b:Populite = new Populite(sh.x + Math.floor(Math.random() * sh.width),sh.y + sh.height - 10);
		b.setGender(false);
		a.setAge(23);
		population.add(b);
		
		add(gui);
	}
	
	public function plant():Void {
		FlxG.log.add("HUI");
	}
}