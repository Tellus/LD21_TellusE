package trial 
{
	import dk.homestead.utils.Calc;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	/**
	 * The lawyer functions mostly like a tick counter, but might serve
	 * other purposes as well.
	 * @author ...
	 */
	public class LawyerEntity extends BaseEntity 
	{
		/**
		 * Average time between ticks.
		 */
		public var AverageTick:Number = 2;
		
		/**
		 * Highest variance between ticks.
		 */
		public var TickVariance:Number = 1;
		
		public var OnTick:Function = null;
		
		public var TickTimer:Alarm;
		
		public function LawyerEntity(tickCallback:Function = null) 
		{
			OnTick = tickCallback;
			_createTimer();
		}
		
		private function _createTimer():void
		{
			TickTimer = new Alarm(_getTickTime(), _onTick, Tween.LOOPING);
			addTween(TickTimer, true);
		}
		
		private function _onTick():void
		{
			ResetTimer();
			if (OnTick != null) OnTick.call(this);
		}
		
		private function _getTickTime():Number
		{
			return Math.random() * (TickVariance * Calc.RandomSign()) + AverageTick;
		}
		
		public function ResetTimer():void
		{
			TickTimer.reset(_getTickTime());
		}
		
		override public function update():void 
		{
			super.update();
		}
	}

}