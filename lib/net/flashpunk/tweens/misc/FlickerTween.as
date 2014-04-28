package net.flashpunk.tweens.misc 
{
	import net.flashpunk.Tween;
	import net.flashpunk.FP;
	
	/**
	 * Flicker randomly the alpha value.
	 */
	public class FlickerTween extends Tween
	{
		/**
		 * The timer.
		 */
		public var timer:Number = 1;
		
		/**
		 * The alpha value.
		 */
		public var alpha:Number = 1;
		
		/**
		 * Constructor.
		 * @param	complete	Optional completion callback.
		 * @param	type		Tween type.
		 */
		public function FlickerTween(complete:Function = null, type:uint = 0) 
		{
			super(0, type, complete);
		}
		
		/**
		 * Flicker randomly.
		 * @param	duration		Duration of the tween.
		 * @param	interval		Time between to alpha change.
		 */
		public function tween(duration:Number, interval:Number):void
		{
			_target = duration;
			_interval = interval;
			timer = interval;
			start();
		}
		
		/** @private Updates the Tween. */
		override public function update():void 
		{
			super.update();
			timer -= FP.elapsed;
			if (timer <= 0) {
				timer = _interval;
				alpha = FP.rand(100) / 100.0;
			}
			if (image) image.alpha = alpha;
		}
		
		// Timer information
		/** @private */ private var _interval:Number;
	}
}