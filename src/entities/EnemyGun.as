package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.Assets;
	import worlds.WorldGame;

	public class EnemyGun extends Enemy {
		private var shootTimer:Number = 3;
		
		public function EnemyGun(x:Number, y:Number) {
			super(x, y, true);
			shootTimer = 2 + FP.rand(20) / 10.0;
		}
		
		override public function update():void {
			super.update();
			shootTimer -= FP.elapsed;
			if (shootTimer <= 0) {
				var bullet:Bullet = world.create(Bullet) as Bullet;
				bullet.initialize(x+1, y+9, x+(FP.choose(-1, 1)*FP.rand(50)), y+(world as WorldGame).playerBeneath.y);
				shootTimer = 5;
			}
		}
		
	}

}