package cutscenes 
{
	import trial.TrialWorld;
	/**
	 * ...
	 * @author ...
	 */
	public class TrialCutscene extends CutsceneWorld 
	{
		[Embed(source = '../../data/trial_intro.txt', mimeType = "application/octet-stream")] public static const TRIAL_TEXT:Class;
		
		// [Embed(source = '../../snd/trial_speak.mp3')] public static var TRIAL_SPEAK:Class;
		[Embed(source = '../../snd/trial_speak_low.mp3')] public static var TRIAL_SPEAK:Class;
		
		public function TrialCutscene() 
		{
			super(TRIAL_TEXT, TRIAL_SPEAK, TrialWorld);
		}
	}
}