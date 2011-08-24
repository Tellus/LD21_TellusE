package evidence
{
	import dk.homestead.utils.Calc;
	import evidence.Character;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Enemy extends BaseEntity 
	{
		[Embed(source='../../img/evidence/enemy.png')] public static const POLICE_SPRITE:Class;
		
		/**
		 * The player that the dude is persuing.
		 */
		public var Target:Character;
		
		/**
		 * Regular movement speed.
		 */
		public static var Speed:Number = 1;
		
		/**
		 * The direction the dude is headed if he can't see the player.
		 */
		public var Direction:Point;
		
		/**
		 * How far the dude can see.
		 */
		public var SightLength:Number = 50;
		
		/**
		 * The left eye of the dude.
		 */
		public var LeftEye:BaseEntity;
		
		/**
		 * The right eye of the dude.
		 */
		public var RightEye:BaseEntity;
		
		/**
		 * Center "eye" used to generate the other two.
		 */
		public var CenterEye:BaseEntity;
		
		public function Enemy() 
		{
			super(0, 0, new Image(POLICE_SPRITE));
			
			LeftEye = new BaseEntity();
			LeftEye.graphic = new Canvas(10, 10);
			(LeftEye.graphic as Canvas).fill(new Rectangle(0, 0, 10, 10), 0x0000FF);
			
			RightEye = new BaseEntity();
			RightEye.graphic = new Canvas(10, 10);
			(RightEye.graphic as Canvas).fill(new Rectangle(0, 0, 10, 10), 0x00FF00);
			
			CenterEye = new BaseEntity();
			CenterEye.graphic = new Canvas(10, 10);
			(CenterEye.graphic as Canvas).fill(new Rectangle(0, 0, 10, 10), 0xAA0000);
			
			LeftEye.visible = RightEye.visible = CenterEye.visible = false;
			
			Direction = new Point(20, 0);
			
			type = "Police";
			
			var i:Image = graphic as Image;
			
			// setHitbox(i.height, i.height);
			// Small hitbox, allows them to follow you through small alleyways.
			
			
			//centerOrigin();
			setHitbox(-3, -3, -(i.scaledWidth / 2), -(i.scaledHeight / 2));
			
			FP.console.watch(Direction);
		}
		
		override public function update():void 
		{
			super.update();
			
			var heading:Point;
			
			if (Target != null)
			{
				heading = Target.Center;
				moveTowards(Target.x, Target.y, Speed, "Building", true);
			}
			else
			{
				heading = Direction;
				moveTowards(Direction.x, Direction.y, 1, "Building", true);
			}
			
			// Base vector for view.
			var view:Point = Calc.calcUnitVector(Center, heading);
			// Extend it to its proper length.
			view.x *= SightLength;
			view.y *= SightLength;
			// Move it over to the center of the entity.
			view.x += centerX;
			view.y += centerY;
			
			CenterEye.x = view.x + CenterEye.halfWidth;
			CenterEye.y = view.y + CenterEye.halfHeight;
			
			var lp:Point = Calc.rotatePoint(new Point(view.x, view.y), new Point(centerX, centerY), -30);
			var rp:Point = Calc.rotatePoint(new Point(view.x, view.y), new Point(centerX, centerY), 30);
			
			LeftEye.Center = lp;
			RightEye.Center = rp;
			
			LeftEye.update();
			RightEye.update();
			CenterEye.update();
			
			// Post running updates.
			Speed += 0.0001; // speed increases every time.
		}
		
		override public function render():void 
		{
			super.render();
			
			if (LeftEye.visible) LeftEye.render();
			if (RightEye.visible) RightEye.render();
			if (CenterEye.visible) CenterEye.render();
		}
	}

}