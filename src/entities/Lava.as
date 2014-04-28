package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;

	public class Lava extends Entity{
		
		public function Lava(x:Number, y:Number) {
			super(x, y, new Image(Assets.LAVA), new Hitbox(16, 10, 0, 6));
			(graphic as Image).alpha = 0.3;
			layer = 5;
			type = "lava";
		}
		
		override public function update():void {
			super.update();
			var p : Player = collide("bro", x, y) as Player;
			if (p) p.die();
			
			var e : Enemy = collide("enemy", x, y) as Enemy;
			if (e) e.kill();
		}
	}

}