require 'ruboto/widget'
require 'ruboto/util/toast'
java_import 'android.media.MediaPlayer'
java_import 'android.view.animation.AnimationUtils'
java_import 'android.content.Context'
java_import 'android.content.SharedPreferences'

ruboto_import_widgets :Button, :ImageButton, :LinearLayout, :TextView

class TuturuActivity
  def onCreate(bundle)
    super
    set_title 'Tuturu'

    self.content_view =
    linear_layout :orientation => :vertical, :gravity => :center, :backgroundColor=> 0xffffffff do
      @title = text_view :text => 'Press Mayushii !', :id => 41,
                :layout => { :width => :match_parent },
                :gravity => :center, :text_size => 20.0, :text_color => 0xff888888
      @nbTuturuTxt = text_view :id => 42,
                :layout => { :width => :match_parent },
                :gravity => :center, :text_size => 20.0, :text_color => 0xff888888
      image_button :backgroundColor => 0x00FFFFFF,
                   :image_resource => $package.R.drawable.tuturu,
                   :id => 43, layout: { :width => :wrap_content },
                   :on_click_listener => proc { play }
    end

    myPrefs = self.getSharedPreferences("myPrefs", MODE_WORLD_READABLE)
    nbTuturu = myPrefs.getString('KeyScore', "");
    @nbTuturuTxt.setText(nbTuturu.to_s)

  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  private

  def play
    sound = rand(0..20) > 16 ? 'tuturulonger' : 'tuturu'
    song = resources.getIdentifier(sound, 'raw', packageName)

    unless @mediaPlayer.nil?
      @mediaPlayer.stop
      @mediaPlayer.release
    end
    unless @title.nil?
      @title.clearAnimation()
    end
    if sound=='tuturulonger'
      @imgBtAnim = AnimationUtils.loadAnimation(self, R.animator.shakelonger)
      @rotate = AnimationUtils.loadAnimation(self, R.animator.rotate)
      @title.startAnimation(@rotate)
    else
      @imgBtAnim = AnimationUtils.loadAnimation(self, R.animator.shake)
    end

    findViewById(43).startAnimation(@imgBtAnim)
    @mediaPlayer = MediaPlayer.create(self, song)
    @mediaPlayer.start
    countTuturu()
    toast 'Tuturu'
  end

  def countTuturu
    myPrefs = self.getSharedPreferences("myPrefs", MODE_WORLD_READABLE);
    nbTuturu = findViewById(42).getText()
    nbTuturu = (nbTuturu.to_i+1).to_s
    @nbTuturuTxt.setText(nbTuturu)
    scorePref = myPrefs.edit();
    scorePref.putString('KeyScore', nbTuturu);
    scorePref.commit();
  end
end
