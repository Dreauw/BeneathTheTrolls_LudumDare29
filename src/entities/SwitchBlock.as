package entities {
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;

	public class SwitchBlock extends Entity{
		private var activated:Boolean = false;
		private var sid:int;
		private var a:Array;
		public function SwitchBlock(x:Number, y:Number, sid:int = 0) {
			super(x, y, new Image(Assets.SWITCH, new Rectangle(16 * sid, 5, 16, 16)), new Hitbox(16, 16));
			this.sid = sid;
			layer = 1;
			type = "solid"
		}
		
		override public function update():void {
			super.update();
			var act : Boolean = false;
			for each (var s:Switch in getSwitch()) {
				if (s.activated) {
					if (type == "solid") {
						type = "notSolid";
						(graphic as Image).alpha = 0.1;
					}
					act = true;
					break;
				} 
			}
			if (!act && type != "solid")  {
				type = "solid";
				(graphic as Image).alpha = 1;
			}
			
			if (type == "solid") {
				var p:Player = collide("bro", x, y) as Player;
				if (p) p.x = x + width + 10;
				var e:Enemy = collide("enemy", x, y) as Enemy;
				if (e) { 
					// Try eject right
					if (!e.collideTypes(new Array("solid", "platform"), x + width + 10, y)) {
						e.x = x + width + 10;
					} else {
						e.y = y + height + e.height;
					}
				}
			}
		}
		
		private function getSwitch():Array {
			if (a == null) {
				a = new Array();
				world.getType("switch"+sid, a);
			}
			return a;
		}
	}

}