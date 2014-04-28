package entities {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.Assets;
	import worlds.WorldGame;

	public class Player extends Entity {
		private const SPEED:int = 20;
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		private var jumpHigh:Number = 0;
		private var img:Spritemap;
		private var mapWidth:Number;
		private var mapHeight:Number;
		public var focused:Boolean = false;
		private var dashDir:Point;
		public var dashTimer:Number = 0;
		public var dashReloadTimer:Number = 0;
		private const DASH_SPEED:int = 900;
		private var jumpCount:int = 0;
		private var haveRocket:Boolean = false;
		public var focus:Boolean = false;
		public var useLess:Boolean = false;
		import utils.Audio;
		
		public function Player(x:Number, y:Number, mapWidth:Number, mapHeight:Number) {
			super(x, y - 7);
			this.mapWidth = mapWidth;
			this.mapHeight = mapHeight;
			img = new Spritemap(Assets.CHARACTERS, 16, 20);
			img.add("stand", [0]);
			img.add("walk", [0, 1, 0, 2], 10);
			img.play("stand");
			img.centerOrigin();
			mask = new Hitbox(12, 20, -8, -10);
			Input.define("Jump", Key.UP, Key.W);
			Input.define("Left", Key.LEFT, Key.A);
			Input.define("Right", Key.RIGHT, Key.D);
			Input.define("Down", Key.DOWN, Key.S);
			layer = 2;
			graphic = img;
			type = "bro";
			Audio.registerSound("hit", "3,,0.0476,,0.2749,0.5772,,-0.5959,,,,,,,,,,,1,,,0.199,,0.5");
			Audio.registerSound("dash", "0,,0.1758,,0.1024,0.3364,,0.2111,,,,,,0.0919,,,,,1,,,0.2332,,0.5");
			Audio.registerSound("dash2", "0,,0.1452,,0.2706,0.313,,0.2416,,,,,,0.3651,,,,,1,,,,,0.5");
			Audio.registerSound("shoot", "0,,0.2293,,0.3132,0.6526,0.0296,-0.3885,,,,,,0.4795,-0.2445,,,,1,,,0.1515,,0.5");
		}
		
		public function centerCamera() : void {
			if (!focus) return;
			var cHeight:Number = (world as WorldGame).beneathView.height;
			FP.camera.x = x - FP.screen.width / (2 * FP.screen.scale);
			FP.camera.y = y - cHeight / 2;
			if (FP.camera.x < 0) FP.camera.x = 0;
			if (FP.camera.y < 0) FP.camera.y = 0;
			if (x + FP.screen.width / (2 * FP.screen.scale) > mapWidth) FP.camera.x = mapWidth - FP.screen.width / 2;
			if (FP.camera.y + cHeight > mapHeight) FP.camera.y = mapHeight - cHeight;
		}
		
		
		override public function update():void {
			super.update();
			if (focus) {
			for (var i:int = 0; i < Input.nbCheck("Jump"); i++ ) {
				if (jumpHigh <= 6 && speedY <= 0) {
					speedY -= 2;
					jumpHigh += 2;
				}
			}
			
			if (Input.check("Left")) {
				speedX -= 40 * FP.elapsed;
				if (jumpHigh == 0 && speedY == 0) img.play("walk");
				img.flipped = true;
			} else if (Input.check("Right")) {
				speedX += 40 * FP.elapsed;
				if (jumpHigh == 0 && speedY == 0) img.play("walk");
				img.flipped = false;
			} else {
				speedX = 0;
				img.play("stand");
			}
			
			
			if (jumpHigh > 0 && dashTimer <= 0) {
				img.angle += img.flipped ? 8 : -8;
			}
			
			
			dashReloadTimer -= FP.elapsed;
			if (Input.mousePressed && dashTimer <= 0 && dashReloadTimer <= 0) {
				if (haveRocket) {
					Audio.playSound("shoot");
					var bullet:BulletRocket = world.create(BulletRocket) as BulletRocket;
					bullet.initialize(x, y, (world as WorldGame).getMouseX(), (world as WorldGame).getMouseY(true), "playerRocket");
					removeRocket();
				} else {
					Audio.playSound(FP.choose("dash", "dash2"));
					dashDir = new Point((world as WorldGame).getMouseX() - x, (world as WorldGame).getMouseY() - y);
					dashTimer = 0.1;
					dashReloadTimer = 1;
				}
			}
			} else {
				speedX = 0;
				img.play("stand");
			}
			
			speedY += SPEED * FP.elapsed;
			if (speedY > 15) speedY = 15;
			if (speedY < -6) speedY = -6;
			if (speedX > 2) speedX = 2;
			if (speedX < -2) speedX = -2;
			
			if (dashTimer > 0) {
				dashDir.normalize(DASH_SPEED * FP.elapsed );
				speedX = dashDir.x;
				speedY = dashDir.y;
				dashTimer -= FP.elapsed;
				if (dashTimer <= 0) speedX = speedY = 0;
				var p:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
				p.layer = this.layer - 1;
				p.initialize(10, x, y, 0, 0, 0.5);
			}
			
			if (collide("water", x, y) && Math.abs(speedX) > 0) {
				speedX = 0.8 * (speedX < 0 ? -1 : 1);
			}
			
			moveBy(speedX, speedY, new Array("solid", "platform"));
			
			if (y < 48 && !useLess) {
				var buff:Array = new Array();
				world.getType("enemy", buff);
				for each(var e:Enemy in buff) {
					e.kill();
				}
				(world as WorldGame).levelComplete();
				focus = false;
				dashReloadTimer = 1;
				useLess = true;
				//(world as WorldGame).loadLevel((world as WorldGame).levelId + 1);
			}
			centerCamera();
			
		}
		
		public function addRocket():void {
			(world as WorldGame).arrow.changeColor(0xFF0000);
			haveRocket = true;
		}
		
		public function removeRocket():void {
			(world as WorldGame).arrow.changeColor(0xFFFFFF);
			haveRocket = false;
		}
		
		public function die():void {
			Audio.playSound("hit");
			if (useLess) return;
			if (this.isRemoved) return;
			
			for (var i:int = 0; i < 8; i++) {
				var p:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
				p.initialize(0, x, y, (i * 360 / 8), 30, 0.5);
			}
			
			dashReloadTimer = 1;
			world.remove(this);
			(world as WorldGame).levelFailed();
			useLess = true;
		}
		
		
		override public function moveCollideY(e:Entity):Boolean {
			if (e is Platform && (y + height - img.originY > e.y || Input.check("Down")) ) return false;
			if (e is Rock && dashTimer > 0) {
				(e as Rock).destroy();
				return false;
			}
			if (speedY >= 0) {
				img.angle = 0;
				jumpHigh = 0;
			}
			speedY = 0;
			
			return super.moveCollideY(e);
		}

		override public function moveCollideX(e:Entity):Boolean {
			if (e is Platform && y + height - img.originY > e.y) return false;
			if (e is Rock && dashTimer > 0) {
				(e as Rock).destroy();
				return false;
			}
			speedX = 0;
			return super.moveCollideX(e);
		}
		
	}

}