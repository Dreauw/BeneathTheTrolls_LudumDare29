package entities {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import net.flashpunk.FP;

	public class SimpleParticle extends Entity{
		private var duration:Number = 0;
		private var dirX:Number;
		private var dirY:Number;
		private var speed:Number;
		private var alphaIncr:Number;
		public function SimpleParticle() {
			layer = 10;
		}
		
		public function initialize(i:int, x:Number, y:Number, angle:Number, speed:Number, duration:Number):void {
			graphic = new Image(Assets.PARTICLES, new Rectangle(i * 10, 0, 10, 10));
			this.x = x;
			this.y = y;
			this.duration = duration;
			this.speed = speed;
			this.dirX = Math.cos(angle * Math.PI / 180);
			this.dirY = Math.sin(angle * Math.PI / 180);
		}
		
		
		override public function update():void {
			super.update();
			duration -= FP.elapsed;
			this.x += dirX * speed * FP.elapsed;
			this.y += dirY * speed * FP.elapsed;
			(this.graphic as Image).alpha -= (1.0 / duration) * FP.elapsed;
			if (duration <= 0) {
				world.recycle(this);
				
			}
		}
	}

}