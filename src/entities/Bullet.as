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

	public class Bullet extends Entity{
		private var dir:Point;
		protected var duration :Number = 10;
		public var speed:Number = 3;
		public var warning:Image;
		private var img:Image;
		private var imgs:Object = {};
		
		public function Bullet() {
			super(0, 0, null, new Hitbox(4, 6));
			img = new Image(Assets.BULLETS);
			img.filters = [new GlowFilter(0xC66709)];
			warning = new Image(Assets.WARNING);
			warning.filters = [new GlowFilter];
			type = "bullet";
			layer = 5;
			graphic = img;
		}
		
		public function initialize(x:Number, y:Number, targetX:Number, targetY:Number, type:String = "bullet") : void {
			this.type = type;
			duration = 10;
			this.x = x;
			this.y = y;
			this.dir = new Point(targetX - x, targetY - y);
			//(graphic as Image).angle = FP.angle(x, y, targetX, targetY) - 90;
		}
		
		public function destroy() : void {
			world.recycle(this);
		}
		
		override public function update():void {
			super.update();
			if (dir) {
				dir.normalize(speed);
				moveBy(dir.x, dir.y, type == "playerRocket" ? "enemy" : "bro");
				duration -= FP.elapsed;
				if (duration <= 0) {
					destroy();
					return;
				}
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean {
			if (e is Player) (e as Player).die();
			destroy();
			return super.moveCollideX(e);
		}

		override public function moveCollideY(e:Entity):Boolean {
			if (e is Player) (e as Player).die();
			destroy();
			return super.moveCollideY(e);
		}
		
	}

}