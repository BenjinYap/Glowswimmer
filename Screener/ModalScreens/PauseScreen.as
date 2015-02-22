package Screener.ModalScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.filters.*;
	import Screener.*;
	import Game.*;
	
	public final class PauseScreen extends BaseScreen {
		private var mouseDownTargets:Array;
		
		public override function Initialize (arg:Object = null) {
			mouseDownTargets = [bttMenu, bttSound, bttMusic];
			
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
				mouseDownTargets [i].addEventListener (MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			}
			
			bttSound.alpha = (GameData.soundOn) ? 1 : 0.2;
			bttMusic.alpha = (GameData.musicOn) ? 1 : 0.2;
			
			Activate ();
		}
		
		public override function Activate (modalScreenMessage:String = null) {
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
		}
		
		public override function Deactivate () {
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		public override function PrepareToDie () {
			Deactivate ();
		
			for (var i:int = 0; i < mouseDownTargets.length; i++) {
				mouseDownTargets [i].removeEventListener (MouseEvent.ROLL_OVER, onRollOver);
				mouseDownTargets [i].removeEventListener (MouseEvent.ROLL_OUT, onRollOut);
				mouseDownTargets [i].removeEventListener (MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function onRollOver (e:MouseEvent) {
			if (e.currentTarget is SimpleButton) {
				if (e.currentTarget.name != "bttSound" && e.currentTarget.name != "bttMusic") {
					var btt:SimpleButton = SimpleButton (e.currentTarget);
					var glow:GlowFilter = btt.filters [0];
					glow.blurX = 32;
					glow.blurY = glow.blurX;
					btt.filters = [glow];
				}
			}
		}
		
		private function onRollOut (e:MouseEvent) {
			if (e.currentTarget is SimpleButton) {
				if (e.currentTarget.name != "bttSound" && e.currentTarget.name != "bttMusic") {
					var btt:SimpleButton = SimpleButton (e.currentTarget);
					var glow:GlowFilter = btt.filters [0];
					glow.blurX = 8;
					glow.blurY = glow.blurX;
					btt.filters = [glow];
				}
			}
		}
		
		public function onMouseDown (e:MouseEvent) {
			if (e.currentTarget == bttMenu) {
				screenMgr.RemoveModalScreen ("quit");
			} else if (e.currentTarget == bttSound) {
				GameData.soundOn = (GameData.soundOn) ? false : true;
				bttSound.alpha = (GameData.soundOn) ? 1 : 0.2;
			} else if (e.currentTarget == bttMusic) {
				GameData.musicOn = (GameData.musicOn) ? false : true;
				bttMusic.alpha = (GameData.musicOn) ? 1 : 0.2;
				
				if (GameData.musicOn) {
					SoundManager.UnmuteMusic ();
				} else {
					SoundManager.MuteMusic ();
				}
			}
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				screenMgr.RemoveModalScreen ("pause");
			}
		}
	}
}
