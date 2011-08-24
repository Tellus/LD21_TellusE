package police 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import net.flashpunk.debug.Console;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	/**
	 * The police nouns are the base obstacles during interrogation.
	 * @author ...
	 */
	public class PoliceNoun extends BaseEntity 
	{
		[Embed(source = '../../data/police_nouns.txt', mimeType = "application/octet-stream")] public static const POLICE_TEXT:Class;
		
		public static var Padding:int = 4;
		
		public static function get Nouns():Vector.<String>
		{
			if (!_nouns) _createNouns();
			return _nouns;
		}
		
		public static function set Nouns(value:Vector.<String>):void { _nouns = value; }
		
		public static var _nouns:Vector.<String>;
		
		public static var FontSize:uint = Text.size;
		
		public static var Speed:Number = 2.0;
		
		public function PoliceNoun()
		{
			super();
			
			var t:Text = new Text(GetNoun(), 0, 0);
			
			/*
			t.originX = 0;
			t.originY = t.height / 2;
			t.angle = -90;
			*/
			
			// graphic = new Canvas(t.height * 2 + Padding, t.width * 2 + Padding);
			graphic = new Canvas(t.width + Padding * 2, t.height + Padding * 2);
			
			var g:Canvas = graphic as Canvas;
			g.fill(new Rectangle(0, 0, g.width, g.height), 0, 1);
			
			g.drawGraphic(g.width / 2 - t.width / 2, 0, t);
			
			setHitbox(g.width, g.height);
			type = "Block";
		}
		
		public function GetNoun():String
		{
			// Modify to write vertically.
			var s:String = Nouns[Math.floor(Math.random() * Nouns.length)];
			var out:String = "";
			// for each (var char:String in s)
			for (var i:int = 0; i < s.length; i++)
			{
				// out += s[i] + "\n";
				out += s.substr(i, 1) + "\n";
			}
			return out.toUpperCase();
		}
		
		private static function _createNouns():void
		{
			var v:Vector.<String> = new Vector.<String>();
			
			var a:Array;
			var bb:ByteArray = new POLICE_TEXT();
			a = bb.toString().split(",");
			
			for each (var s:String in a)
			{
				// trace("Parsed " + s);
				v.push(s);
			}
			
			Nouns = v;
		}
		
		public function Destroy():void
		{
			world.remove(this);
		}
		
		override public function update():void 
		{
			super.update();
			
			moveBy( -Speed, 0);
			
			if (collide("Player", x, y) != null)
			{
				collidable = false;
				(world as InterrogationWorld).Hurt();
				trace("Block nulled");
			}
		}
	}

}