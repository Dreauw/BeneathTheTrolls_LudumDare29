package utils {
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import flash.display.BitmapData;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class WorldBase extends World {
		private var _classToGo:Class;
		private var _func:Function;
		protected var inTransition:Boolean = false;
		private var fadeAlpha:Number = 0;
		private var fadeIn:Boolean = false;
		
		public function switchWorld(classToGo:Class):void {
			_classToGo = classToGo;
			if (inTransition) return;
			transitionIn();
		}
		
		public function executeTransition(func:Function = null) : void {
			if (inTransition) return;
			transitionIn();
			_func = func;
		}
		
		public function transitionOut():void {
			inTransition = true;
			fadeIn = false;
			fadeAlpha = 255;
		}
		
		public function transitionIn():void {
			inTransition = true;
			fadeIn = true;
			fadeAlpha = 0.1;
		}
		
		
		override public function update():void {
			super.update();
			if (inTransition) fadeAlpha += (fadeIn ?  12.75 : -12.75);
			if (Input.released(Key.M)) Audio.mute();
		}
		
		override public function focusGained():void {
			if (FP.engine.paused) {
				FP.engine.paused = false;
				Audio.resume();
				super.focusGained();
			}
		}
		
		override public function focusLost():void {
			FP.engine.paused = true;
			Audio.stop();
			FP.engine.render();
			super.focusGained();
		}
		
		override public function render():void {
			super.render();
			if (inTransition) {
				var bd:BitmapData = new BitmapData((FP.screen.width / FP.screen.scale), (FP.screen.height / FP.screen.scale), true, fadeAlpha<<24);
				FP.buffer.copyPixels(bd, bd.rect, new Point(0, 0));
				if (fadeAlpha >= 255) {
					transitionOut();
					if (_func != null) _func.call();
					if (_classToGo) {
						var worldTo:WorldBase = new _classToGo();
						FP.world = worldTo;
						worldTo.transitionOut();
					}
				}
				if (fadeAlpha <= 0) inTransition = false;
			}
			
			if (!FP.focused) {
				var bdf:BitmapData = new BitmapData((FP.screen.width / FP.screen.scale) + (FP.screen.width / FP.screen.scale) / 2, (FP.screen.height / FP.screen.scale), true, 0xAA000000);
				FP.buffer.copyPixels(bdf, bdf.rect, new Point(0, 0));
			}
			
		}
	}

}