package cutscenes 
{
	import net.flashpunk.Sfx;
	import police.InterrogationWorld;
	/**
	 * ...
	 * @author ...
	 */
	public class InterrogationCutscene extends CutsceneWorld 
	{
		[Embed(source = '../../data/interrogation_intro.txt', mimeType = "application/octet-stream")] public static const INTRO_TEXT:Class;
		
		//[Embed(source = '../../snd/police_speak.mp3')] public static const INTRO_SPEAK:Class;
		[Embed(source = '../../snd/police_speak_low.mp3')] public static const INTRO_SPEAK:Class;
		
		public function InterrogationCutscene() 
		{
			super(INTRO_TEXT, INTRO_SPEAK, InterrogationWorld);
		}
	}
}