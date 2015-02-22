package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	
	public final class Player extends MovieClip {
		public var ySpeed:Number = 0;
		public var rising:Boolean = false;
		
		public function Initialize () {
			width = GameData.avatarSize.x;
			height = GameData.avatarSize.y;
		}
		
		public function Activate () {
			play ();
			stage.addEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown, false, 0, true);
			stage.addEventListener (MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
			stage.addEventListener (KeyboardEvent.KEY_UP, onStageKeyUp, false, 0, true);
		}
		
		public function Deactivate () {
			rising = false;
			stop ();
			stage.removeEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown);
			stage.removeEventListener (MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
			stage.removeEventListener (KeyboardEvent.KEY_UP, onStageKeyUp);
		}
		
		private function onStageMouseDown (e:MouseEvent) {
			rising = true;
		}
		
		private function onStageMouseUp (e:MouseEvent) {
			rising = false;
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.SPACE) {
				rising = true;
			}
		}
		
		private function onStageKeyUp (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.SPACE) {
				rising = false;
			}
		}
	}
}