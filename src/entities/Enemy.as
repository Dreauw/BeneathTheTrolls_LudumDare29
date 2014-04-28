package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import worlds.WorldGame;
	import utils.Audio;

	public class Enemy extends Entity{
		
		private var img:Spritemap;
		private var shootTimer:Number = 0;
		public var direction:int = -1;
		public var speed:int = 1;
		private var lastY:Number = 0;
		
		public function Enemy(x:Number, y:Number, gun:Boolean = false) {
			super(x+8, y);
			mask = new Hitbox(10, 16);
			layer = 3;
			img = new Spritemap(Assets.CHARACTERS, 16, 20);
			var i:int = gun ? 6 : 3;
			img.add("stand", [i]);
			img.add("walk", [i, i+1, i, i+2], 10);
			img.play("stand");
			img.centerOrigin();
			mask = new Hitbox(12, 20, -8, -10);
			graphic = img;
			type = "enemy";
			Audio.registerSound("enemy", "3,,0.1672,0.4436,0.3411,0.1496,,-0.2631,,,,,,,,0.5658,,,1,,,,,0.5");
		}
		
		override public function update():void {
			super.update();
			if (y - lastY == 0) {
				if (speed > 0) img.play("walk");
				img.flipped = direction < 0;
				if (speed + x < 0 || speed + x > (world as WorldGame).map.levelWidth ||
				!collideTypes(["solid", "platform"], x+speed*direction+(width*direction), y+height/2)) {
					direction = -direction
				}
			} else {
				lastY = y;
			}
			
			moveBy(speed*direction, 2, new Array("solid", "platform"));
			var p : Player = collide("bro", x, y) as Player;
			if (p) {
				if (p.dashTimer > 0) {
					kill();
				} else {
					p.die();
				}
			}
			
			
		}
		
		public function kill() : void {
			if (this.isRemoved) return;
			
			Audio.playSound("enemy");
			for (var i:int = 0; i < 8; i++) {
				var p:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
				p.initialize(0, x, y, (i * 360 / 8), 30, 0.5);
			}
			
			world.remove(this);
		}
		
		
		override public function moveCollideX(e:Entity):Boolean {
			direction = -direction;
			return super.moveCollideX(e);
		}
	}

}