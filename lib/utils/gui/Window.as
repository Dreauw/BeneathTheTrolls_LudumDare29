package utils.gui {
	import flash.display.Shape;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import flash.filters.GlowFilter;
	import net.flashpunk.graphics.Text;
	public class Window extends Entity {
		protected var text:Text;
		private var color:uint;
		private const ALPHA : Number = 0.3;
		private var image:Image;
		public function Window(x:Number, y:Number, width:Number = 0, height:Number = 0, txt:String = "", color:uint = 0) {
			super(x, y);
			this.color = color;
			text = new Text("", 8, 8, {size: 8});
			setText(txt, width, height);
			addGraphic(text);
		}
		
		public function setSize(width:Number, height:Number) : void {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color, ALPHA);
			shape.graphics.drawRect(5, 5, width+5, height+5);
			shape.graphics.endFill();
			graphic = Image.createFromShape(shape);
			shape.graphics.clear();
			shape.filters = [new GlowFilter(0, 1, 2, 2, 2)];
			shape.graphics.lineStyle(1, 0xFFFFFF, 1, true);
			shape.graphics.drawRect(5, 5, width, height);
			shape.graphics.endFill();
			shape.width += 10;
			shape.height += 10;
			shape.alpha = ALPHA;
			addGraphic(Image.createFromShape(shape));
		}
		
		public function setText(txt:String, wWidth:Number = 0, wHeight:Number = 0) : void {
			text.text = txt;
			if (wWidth == 0) wWidth = text.width + 4;
			if (wHeight == 0) wHeight = text.height + 4;
			setSize(wWidth, wHeight)
		}
		
	}

}