package evidence 
{
	import dk.homestead.flashpunk.groups.EntityGroup;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	/**
	 * Information about what's going wrong in the game.
	 * @author ...
	 */
	public class GuiLayer extends EntityGroup 
	{
		[Embed(source = '../../img/evidence/police_icon.png')] public static const POLIC_ICON:Class;
		[Embed(source = '../../img/evidence/lootBag.png')] public static const LOOT_ICON:Class;
		
		/**
		 * Last police to be added to the icon list.
		 */
		public var LastPolice:BaseEntity;
		
		/**
		 * Various police banter
		 */
		public var RandomTalk:BaseEntity;
		
		/**
		 * List of the loot bag icons.
		 */
		public var Loot:Vector.<BaseEntity> = new Vector.<BaseEntity>();
		
		/**
		 * How much loot is left.
		 */
		public var LootCount:int;
		
		public var Background:BaseEntity;
		
		public var LootCounter:BaseEntity;
		
		public function GuiLayer() 
		{
			LootCount = EvidenceWorld.LOOT_COUNT;
			
			setHitbox(FP.width, FP.height * 0.2);
			
			MoveFactorX = MoveFactorY = 1.0;
			
			_createPC();
			_createRT();
			_createLC();
			_createBG();
		}
		
		private function _createPC():void
		{
			var p:BaseEntity = _createPoliceIcon();
			p.x = p.y = 10;
			LastPolice = p;
		}
		
		private function _createRT():void
		{
			RandomTalk = new BaseEntity(0, 0, new Text("Wootage!"));
			RandomTalk.x = 10;
			RandomTalk.y = height - (RandomTalk.graphic as Text).height - 10;
			add(RandomTalk);
		}
		
		private function _createLC():void
		{
			var spawnArea:Point = new Point(width - height * 1.5, 0); // Makes it square. Nice!
			var e:BaseEntity;
			for (var i:int = 0; i < EvidenceWorld.LOOT_COUNT; i++)
			{
				e = new BaseEntity(0, 0, new Image(LOOT_ICON));
				var g:Image = e.graphic as Image;
				e.setHitbox(g.width, g.height);
				e.x = Math.random() * (height - e.width ) + spawnArea.x;
				e.y = Math.random() * (height - e.height);
				Loot.push(e);
				add(e);
			}
			
			LootCounter = new BaseEntity(0, 0, new Text(LootCount.toString()));
			LootCounter.x = spawnArea.x;
			LootCounter.y = spawnArea.y;
			add(LootCounter);
		}
		
		private function _createBG():void
		{
			Background = new BaseEntity(0, 0, new Canvas(width, height));
			var g:Canvas = Background.graphic as Canvas;
			g.fill(new Rectangle(0, 0, g.width, g.height), 0x000000, 0.7);
			add(Background);
		}
		
		public function AddPolice():void
		{
			var p:BaseEntity = _createPoliceIcon();
			// p.x = PoliceCounter[PoliceCounter.length - 1].x;
			p.x = LastPolice.x + 30;
			p.y = LastPolice.y;
			LastPolice = p;
			trace("Officer added at " + new Point(p.x, p.y).toString());
		}
		
		public function DropLoot():void
		{
			(Loot[Math.max(--LootCount, 0)].graphic as Image).alpha = 0.3;
			(LootCounter.graphic as Text).text = LootCount.toString();
		}
		
		private function _createPoliceIcon():BaseEntity
		{
			var p:BaseEntity = new BaseEntity(0, 0, new Image(POLIC_ICON));
			add(p);
			try 
			{
				MoveToBottom(Background);
			}
			catch (err:Error)
			{
				trace("Couldn't move Background. Nevermind.");
			}
			return p;
		}
		
		override public function update():void 
		{
			if (Input.check(Key.O)) y--;
			if (Input.pressed(Key.NUMPAD_MULTIPLY)) AddPolice();
			
			super.update();
		}
	}

}