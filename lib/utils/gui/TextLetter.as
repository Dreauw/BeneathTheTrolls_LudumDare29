package utils.gui {
	import flash.geom.Point;
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	import flash.text.TextFormat;

	public class TextLetter extends Text {
		public var delay:Number = 0.03;
		private var timer:Number = delay;
		public function TextLetter(text:String, x:Number = 0, y:Number = 0, options:Object = null, h:Number = 0) {
			super(text, x, y, options, h);
			_field.maxChars = 0;
		}

		override public function set richText(value:String):void {
			_field.maxChars = 0;
			timer = delay;
			super.richText = value;
		}

		override public function set text(value:String):void {
			_field.maxChars = 0;
			timer = delay;
			super.text = value;
		}

		override public function render(target:BitmapData, point:Point, camera:Point):void {
			if (timer > 0 && FP.frameRate) {
				timer -= FP.elapsed;
				if (timer <= 0) {
					_field.maxChars += 1;
					if ((_richText ? _richText.length : _text.length) > _field.maxChars) timer = delay;
					if (_filters && _filters.length > 0) this.filters = this.filters;
					updateTextBuffer();
				}
			}
			super.render(target, point, camera);
		}

		override protected function matchStyles():void {
			var originalText:String = _richText;
			_richText = originalText.slice(0, _field.maxChars);
			if (_richText.charAt(_richText.length - 1) == "<") {
				while (_richText.charAt(_richText.length - 1) != ">") {
					_field.maxChars += 1;
					_richText = originalText.slice(0, _field.maxChars);
				}
			}
			super.matchStyles();
			_richText = originalText;
		}

		override public function updateTextBuffer():void {
			_field.text = _text.slice(0, _field.maxChars);
			super.updateTextBuffer();
		}

		public function animationFinished():Boolean {
			return _field.maxChars == (_richText ? _richText.length : _text.length)
		}

		public function skip():void {
			_field.maxChars = (_richText ? _richText.length : _text.length);
			updateTextBuffer();
		}

	}
}