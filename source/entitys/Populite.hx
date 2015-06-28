package source.entitys;

import flixel.FlxSprite;
import flixel.FlxG;
import source.effects.FadeText;
import source.world.Resource;
import source.world.Tree;
import source.world.Building;
import flixel.group.FlxTypedGroup;
import PlayState;

/**
 * ...
 * @author Elliot Lee-Cerrino
 */

 enum AvalibleTasks {
		wonder;
		gatherFood;
		gatherResr;
		gotoStore;
	}
	
class Populite extends FlxSprite
{

	public var male:Bool;
	public var age:Int;
	public var mate:Bool;
	public var currentTask:EnumValue;
	
	public var tasks:Enum<AvalibleTasks>;
	
	public var vision:Float = 48;
	
	public var tx:Float;
	public var ty:Float;
	public var data:Map<String,String>;
	public var currentItem:Resource;
	public var currentBuildingLoc:Building;
	
	public var targetLocation:Dynamic;
	public var actionTimer:Int;
	public var speed:Float;
	public var full:Bool;
	public function new(x:Float, y:Float)
	{
		super(x, y);
		this.tx = x;
		this.ty = y;
		this.male = (Math.random() > 0.5);
		this.age = Math.round(Math.random() * 75) + 1;
		this.tasks = AvalibleTasks;
		this.currentTask = AvalibleTasks.wonder;
		this.data = new Map<String,String>();
		this.actionTimer = 0;
		if (this.male)
			this.makeGraphic(16, 16, 0xFF0000FF);
		else
			this.makeGraphic(16, 16, 0xFFFF00FF);
			
		if (this.age < 12) this.setGraphicSize(8, 8);
		this.data.arrayWrite("Name", getName());
		this.data.arrayWrite("Age", ""+age);
		this.data.arrayWrite("Male", "" + male);
		
		this.speed = (1.3 * (age > 12 ? 1: 1.5)) / 2;
	}
	
	override public function update():Void {
		if (currentTask == AvalibleTasks.wonder) {
			if (isinRad(tx,ty,5)) {
				this.tx = Math.ffloor(Math.random() * (640 - 16));
				this.ty = Math.ffloor(Math.random() * (480 - 16));
			}else {
				var a:Float = Helper.getAngle(this.x, this.y, this.tx, this.ty);
				this.x -= Math.cos(a) * speed;
				this.y -= Math.sin(a) * speed;
			}
		}else if (currentTask == AvalibleTasks.gatherFood) {
			
		}else if (currentTask == AvalibleTasks.gatherResr) {
			if (full) {
				var da:Float = 100000;
				var s:PlayState = cast(FlxG.state, PlayState);
				var build:FlxTypedGroup<Building> = s.buildings;
				for (i in 0...build.length) {
					var loc:Building = build.members[i];
					if (Helper.getStraightLineDist(this.x, this.y, loc.x, loc.y) < da) {
						da = Helper.getStraightLineDist(this.x, this.y, loc.x, loc.y);
						this.tx = loc.x;
						this.ty = loc.y;
						this.currentBuildingLoc = loc;
					}
				}
				currentTask = AvalibleTasks.gotoStore;
			}
			else if (targetLocation != null && !full) {
				if (Std.is(targetLocation, Tree)) {
					var t:Tree = cast(targetLocation, Tree);
					if (isinRad(t.x, t.y+t.height-10)) {
						if (--actionTimer <= 0) {
							fade("+1");
							t.hurt(5);
							actionTimer = 60;
							this.currentItem = t.drop;
							FlxG.watch.addQuick("Amt Held:", this.currentItem.value);
							if (this.currentItem != null) {
								this.full = true;
							}
						}
					}else {
						var a:Float = Helper.getAngle(this.x, this.y, t.x + t.width / 2, t.y + t.height - 10);
						this.x -= Math.cos(a) * speed;
						this.y -= Math.sin(a) * speed;
					}
				}
			}else if (targetLocation = null) {
				currentTask = AvalibleTasks.wonder;
			}
		}
		else if (currentTask == AvalibleTasks.gotoStore) {
			if (currentBuildingLoc == null) currentTask = AvalibleTasks.wonder;
			if (isinRad(currentBuildingLoc.x + currentBuildingLoc.width / 2, currentBuildingLoc.y + currentBuildingLoc.height /2,64)) {
				if (--this.actionTimer <= 0) {
					if(currentItem.value > 0){
						currentBuildingLoc.placeInStoreage(currentItem.type, 1);
						FlxG.log.add(currentBuildingLoc.getAmountOfSpecific(currentItem.type));
						currentItem.value--;
						actionTimer = 60;
						fade("-1");
					}else {
						this.full = false;
						currentTask = AvalibleTasks.gatherResr;
					}
				}
			}
			else {
				var a:Float = Helper.getAngle(this.x, this.y, tx, ty);
				this.x -= Math.cos(a) * speed;
				this.y -= Math.sin(a) * speed;
			}
		}
		var r:Float = this.width;
		if ((FlxG.mouse.x >= this.x && FlxG.mouse.y >= this.y && FlxG.mouse.x  <= this.x + r && FlxG.mouse.y  <=this.ty + r) && FlxG.mouse.pressed) {
			Helper.selectedPop = this;
			FlxG.watch.addQuick("Name:", this.data.get("Name"));
			FlxG.watch.addQuick("Amt Held:", this.currentItem);
		}
	}
	
	public function ageInc():Void {
		if (++this.age == 12) {
			this.setGraphicSize(16, 16);
		}
	}
	
	private function isin():Bool {
		var r:Float = 0;
		if (this.x >= this.tx && this.y >= this.ty && this.x + r <= this.tx + this.width && this.y + r <= this.ty + this.width) return true;
		else return false;
	}
	
	private function isin2(x2:Float, y2:Float, ?r:Float = 1.5):Bool {
		if (this.x >= x2 && this.y >= y2 && this.x + r <= x2 && this.y + r <= y2) return true;
		else return false;
	}
	
	private function isinRad(x2:Float, y2:Float, ?r:Float = 10):Bool {
		return Helper.getStraightLineDist(this.x,this.y,x2,y2) <= r;
	}
	
	private function getName():String {
		var mn = ["John", "Mark", "Dan", "Derek", "Kyle", "Elliot"];
		var fn = ["Jane", "Mary", "Sal", "Sandra", "Katlin", "Megan"];
		if (male) return mn[Math.floor(Math.random() * mn.length)];
		else return fn[Math.floor(Math.random() * fn.length)];
	}
	
	private function fade(t:String):Void {
		FlxG.state.add(new FadeText(this.x + this.width / 2, this.y - 10,t));
	}
}