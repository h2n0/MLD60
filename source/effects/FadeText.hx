package source.effects;

import flixel.text.FlxText;

/**
 * ...
 * @author Elliot Lee-Cerrino
 */
class FadeText extends FlxText
{

	public function new(x:Float,y:Float,text:String) 
	{
		super(x, y, -1, text);
		this.color = 0xFFFFFFFF;
	}
	
	override public function update():Void {
		if (this.alpha <= 0) this.destroy();
		this.y--;
		this.alpha -= 0.05;
	}
	
}