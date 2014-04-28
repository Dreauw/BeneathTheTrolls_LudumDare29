package entities {
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import utils.Assets;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import worlds.WorldGame;

	public class Map extends Entity{
		public var loaded:Boolean = false;
		public var id:uint = 0;
		private var tilesTable:Object = { 255:0, 254:1, 251:2, 127:3, 223:4, 250:5, 123:6, 95:7, 222:8, 126:9, 219:10, 122:11, 91:12, 94:13, 218:14, 90:15, 248:16, 107:17, 31:18, 214:19, 104:20, 11:21, 22:22, 208:23, 24:24, 66:25, 8:26, 2:27, 16:28, 64:29, 0:30, 106:31, 27:32, 86:33, 216:34, 30:35, 210:36, 120:37, 75:38, 10:39, 18:40, 80:41, 72:42, 26:43, 82:44, 88:45, 74:46 };
		private var levelRect:Array = new Array();
		private var img:Image;
		public var levelWidth:int = 0;
		public var levelHeight:int = 0;
		public var maxLevel:int = 0;
		
		public function Map() {
			type = "solid";
			layer = 1;
			img = new Image(Assets.LEVEL);
			var starty:int = -1;
			var endx:int = -1;
			for (var y:int = 0 ; y < img.height ; y++) {
				if (img.getPixel(1, y) == 0) {
					if (starty >= 0) {
						levelRect.push(new Rectangle(1, starty, endx, y - starty));
					}
					starty = y + 1;
					for (var x:int = 1 ; x < img.width ; x++) {
						if (img.getPixel(x, y + 1) == 0) {
							endx = x - 1;
							break;
						}
					}
				}
			}
			maxLevel = levelRect.length;
		}

		public function loadLevel(level:uint, worldGame:WorldGame) : void {
			FP.camera.x = FP.camera.y = 0;
			var rect:Rectangle = levelRect[level];
			levelWidth = rect.width * 16;
			levelHeight = rect.height * 16;
			var tilemap:Tilemap = new Tilemap(Assets.TILESET, rect.width * 16 , rect.height * 16, 16, 16);
			var grid:Grid = new Grid(rect.width * 16, rect.height * 16, 16, 16);
			
			for (var xx:int = rect.x; xx < rect.x+rect.width ; xx++) {
				for (var yy:int = rect.y ; yy < rect.y + rect.height ; yy++) {
					var posx:Number = xx - rect.x;
					var posy:Number = yy - rect.y;
					var col:uint = img.getPixel(xx, yy);
					
					
					if (col == 0xB97A57) {
						var id:int = getAutoTile(new Array(col, 0, 0x835136), xx, yy);
						tilemap.setTile(posx, posy, id);
						// Near the surface
						if (posy < 10) { 
							if (id == 16) {
								tilemap.setTile(posx, posy-1, FP.choose(96, 97, 99, 100));
							} else if (id == 20 || id == 23 || id == 24 || id == 26 || id == 28 || id == 29 || id == 30 || id == 45 || id == 41 || id == 42 || id == 37 || id == 34) {
								tilemap.setTile(posx, posy-1, 98);
							}
						}
						grid.setTile(posx, posy);
					} else if (col == 0x835136) {
						var id2:int = getAutoTile(new Array(col, 0, 0xB97A57), xx, yy);
						tilemap.setTile(posx, posy, id2+48);
						grid.setTile(posx, posy);
					} else if (col == 0x00FF00) { // Player Beneath
						worldGame.playerBeneath = new Player(posx * 16, posy * 16, rect.width * 16, rect.height * 16);
						worldGame.add(worldGame.playerBeneath);
					} else if (col == 0x0000FF) {
						worldGame.add(new Platform(posx * 16, posy * 16));
					} else if (col == 0xFF00FF) {
						worldGame.add(new EnemyGun(posx * 16, posy * 16));
					} else if (col == 0xCF3048) {
						(worldGame.add(new EnemyGun(posx * 16, posy * 16)) as EnemyGun).speed = 0;
					} else if (col == 0x8856A9) {
						(worldGame.add(new Enemy(posx * 16, posy * 16)) as Enemy);
					} else if (col == 0x531DE2) {
						(worldGame.add(new Enemy(posx * 16, posy * 16)) as Enemy).speed = 0;
					} else if (col == 0xFFFF00) {
						worldGame.add(new Torch(posx * 16, posy * 16));
					} else if (col == 0xC3C3C3) {
						worldGame.add(new Rocket(posx * 16, posy * 16));
					} else if (col == 0x00A2E8) {
						worldGame.add(new Diamond(posx * 16, posy * 16));
					} else if (col == 0xA349A4) {
						worldGame.add(new Rock(posx * 16, posy * 16));
					} else if (col == 0x7092be) {
						worldGame.add(new Water(posx * 16, posy * 16));
						// Auto border with tile
						if (img.getPixel(xx - 1, yy) != col) {
							var wt:Image = new Image(Assets.WATER, new Rectangle(0, 0, 8, 16));
							wt.alpha = 0.3;
							worldGame.addGraphic(wt, 1, posx * 16 - 8, posy * 16);
						}
						if (img.getPixel(xx + 1, yy) != col) {
							var wat:Image = new Image(Assets.WATER, new Rectangle(0, 0, 8, 16));
							wt.alpha = 0.3;
							worldGame.addGraphic(wt, 1, posx * 16 + 16, posy * 16);
						}
					} else if (col == 0xFF0000) {
						worldGame.add(new Switch(posx * 16, posy * 16, 0));
					} else if (col == 0x2DD2D2) {
						worldGame.add(new Switch(posx * 16, posy * 16, 1));
					} else if (col == 0x22B14C) {
						worldGame.add(new Switch(posx * 16, posy * 16, 2));
					} else if (col == 0x640000) {
						worldGame.add(new SwitchBlock(posx * 16, posy * 16, 0));
					} else if (col == 0x219898) {
						worldGame.add(new SwitchBlock(posx * 16, posy * 16, 1));
					} else if (col == 0x177b35) {
						worldGame.add(new SwitchBlock(posx * 16, posy * 16, 2));
					} else if (col == 0xFF7F27) {
						worldGame.add(new Lava(posx * 16, posy * 16));
						// Auto border with tile
						if (img.getPixel(xx - 1, yy) != col) {
							var lv:Image = new Image(Assets.LAVA, new Rectangle(0, 0, 8, 16));
							lv.alpha = 0.3;
							worldGame.addGraphic(lv, 1, posx * 16 - 8, posy * 16);
						}
						if (img.getPixel(xx + 1, yy) != col) {
							var lav:Image = new Image(Assets.LAVA, new Rectangle(0, 0, 8, 16));
							lav.alpha = 0.3;
							worldGame.addGraphic(lav, 1, posx * 16 + 16, posy * 16);
						}
					} else if (col == 1) {
						var t1:Text = new Text("Reach the surface\nMove with arrow keys or WASD", 5, 220, { size:8 } );
						t1.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
						worldGame.addGraphic(t1, 12);
					} else if (col == 2) {
						var t2:Text = new Text("Use your mouse to dash\nWith your dash you can destroy things like rocks", 5, 220, { size:8 } );
						t2.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
						worldGame.addGraphic(t2, 12);
					} else if (col == 3) {
						var t3:Text = new Text("Pressure plate control the blocks of the same color", 5, 230, { size:8 } );
						t3.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
						worldGame.addGraphic(t3, 12);
					} else if (col == 4) {
						var t4:Text = new Text("You can use rocket to shoot an enemy\nAim and shoot with the mouse", 5, 230, { size:8 } );
						t4.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
						worldGame.addGraphic(t4, 12);
					} else if (col == 5) {
						var t5:Text = new Text("Even if you are really deep, you always see the surface\nLike that, you can avoid the bullets", 5, 230, { size:8 } );
						t5.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
						worldGame.addGraphic(t4, 12);
					}
				}
			}
			
			graphic = tilemap;
			mask = grid;
			loaded = true;
		}

		public function getNeighbours(col:Array, x:uint, y:uint) : Array {
			var neigh:Array = new Array();
			neigh.push(col.indexOf(img.getPixel(x - 1, y - 1)) >= 0, col.indexOf(img.getPixel(x, y - 1)) >= 0, col.indexOf(img.getPixel(x + 1, y - 1)) >= 0);
			neigh.push(col.indexOf(img.getPixel(x - 1, y))     >= 0, col.indexOf(img.getPixel(x + 1, y)) >= 0);
			neigh.push(col.indexOf(img.getPixel(x - 1, y + 1)) >= 0, col.indexOf(img.getPixel(x, y + 1)) >= 0, col.indexOf(img.getPixel(x + 1, y + 1)) >= 0);
			if (!neigh[3] || !neigh[1]) neigh[0] = false;
			if (!neigh[3] || !neigh[6]) neigh[5] = false;
			if (!neigh[4] || !neigh[1]) neigh[2] = false;
			if (!neigh[4] || !neigh[6]) neigh[7] = false;
			return neigh;
		}
		
		public function getAutoTile(col:Array, x:uint, y:uint):uint {
				var neigh:Array = getNeighbours(col, x, y);
				var id:int = 0;
				for (var i:int = 0; i < neigh.length; i++) {
					id += neigh[i] * Math.pow(2, i);
				}
				return tilesTable[id];
		}

		override public function update():void {
			super.update();
			//if (x + realWidth < FP.camera.x ) (FP.world as WorldGame).recycleChunk(this);
		}

	}

}