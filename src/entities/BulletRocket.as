package entities {
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.TiledImage;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import net.flashpunk.FP;
	import worlds.WorldGame;

	public class BulletRocket extends Entity{
		private var dir:Point;
		protected var duration :Number = 10;
		public var speed:Number = 7;
		private var img:Image;
		private var imgs:Object = { };
		public var warning:Image;
		
		public function BulletRocket() {
			super(0, 0, null, new Hitbox(11, 15));
			img = new Image(Assets.ROCKET_BLUE);
			warning = new Image(Assets.WARNING);
			warning.color = 0x0088FF;
			type = "playerRocket";
			layer = 5;
			graphic = img;
			img.centerOO();
		}
		
		public function initialize(x:Number, y:Number, targetX:Number, targetY:Number, type:String = "bullet") : void {
			this.type = type;
			duration = 2;
			this.x = x;
			this.y = y;
			this.dir = new Point(targetX - x, targetY - y);
			(graphic as Image).angle = FP.angle(x, y, targetX, targetY) - 90;
		}
		
		public function destroy() : void {
			world.recycle(this);
		}
		
		override public function update():void {
			super.update();
			if (dir) {
				dir.normalize(speed);
				moveBy(dir.x, dir.y, "enemy");
				duration -= FP.elapsed;
				if (duration <= 0) {
					destroy();
					return;
				}
				var sp:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
				sp.layer = 4;
				sp.initialize(2, x-2, y, FP.rand(360), 5, 0.2);
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			
			(e as Enemy).kill();
			destroy();
			return super.moveCollideX(e);
		}

		override public function moveCollideY(e:Entity):Boolean {
			(e as Enemy).kill();
			destroy();
			return super.moveCollideY(e);
		}
		
	}

}