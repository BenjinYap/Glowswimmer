package {
	import flash.display.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.events.*;
	import Game.*;
	
	public class SoundManager {
		public static var channel:SoundChannel;
		public static var isMusicPlaying:Boolean = false;
		private static var sounds:Array = [sndBreathe1, sndBreathe2, sndTongue1, sndTongue2, sndTongue3, sndAhh];
		private static var thought:SoundChannel;
		
		public static function PlayStrangeSound () {
			if (GameData.soundOn) {
				new sounds [Math.floor (Math.random () * sounds.length)] ().play ();
			}
		}
		
		public static function PlayTreasureGet () {
			if (GameData.soundOn) {
				new sndTreasureGet ().play ();
			}
		}
		
		public static function PlayMusic () {
			if (isMusicPlaying == false) {
				channel = new sndMusic ().play ();
				channel.addEventListener (Event.SOUND_COMPLETE, onMusicComplete, false, 0, true);
				isMusicPlaying = true;
				
				if (GameData.musicOn == false) {
					MuteMusic ();
				}
			}
		}
		
		private static function onMusicComplete (e:Event) {
			channel.removeEventListener (Event.SOUND_COMPLETE, onMusicComplete);
			channel = new sndMusic ().play ();
			channel.addEventListener (Event.SOUND_COMPLETE, onMusicComplete, false, 0, true);
			
			if (GameData.musicOn == false) {
				MuteMusic ();
			}
		}
		
		public static function MuteMusic () {
			var st:SoundTransform = new SoundTransform (0);
			channel.soundTransform = st;
		}
		
		public static function UnmuteMusic () {
			var st:SoundTransform = new SoundTransform (1);
			channel.soundTransform = st;
		}
		
		public static function StopMusic () {
			channel.stop ();
			channel.removeEventListener (Event.SOUND_COMPLETE, onMusicComplete);
			isMusicPlaying = false;
		}
		
		public static function FadeOutMusic () {
			var st:SoundTransform = new SoundTransform ();
			st.volume = channel.soundTransform.volume;
			//st.volume -= 1 / GameData.musicFadeOutFrames;
			
			if (st.volume > 0) {
				channel.soundTransform = st;
			}
		}
		
		public static function PlayThought (soundClass:Class) {
			if (GameData.soundOn) {
				if (thought != null) {
					thought.stop ();
				}
				
				thought = new soundClass ().play ();
			}
		}
	}
}