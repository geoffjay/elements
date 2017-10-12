//using Config;
using SDL;
using SDLGraphics;

namespace Util {
    public const string PACKAGE_NAME = "elements";
    public const string PACKAGE_VERSION = "0.1.0";
    public const string DATADIR = "/usr/local/elements/";
}

public class ApplicationWindow : Object {

    private const int SCREEN_WIDTH = 640;
    private const int SCREEN_HEIGHT = 480;
    private const int SCREEN_BPP = 32;
    private const int DELAY = 10;

    private Video.Window window;
    private Video.Renderer? renderer;
    private GLib.Rand rand;
    private bool done;

    public ApplicationWindow () {
        this.rand = new GLib.Rand ();
    }

    public void run () {
        init_video ();

        while (!done) {
            draw ();
            process_events ();
            SDL.Timer.delay (DELAY);
        }
    }

    private void init_video () {
		window = new Video.Window ("Elements",
                                   Video.Window.POS_CENTERED,
                                   Video.Window.POS_CENTERED,
                                   SCREEN_WIDTH,SCREEN_HEIGHT,
                                   Video.WindowFlags.RESIZABLE);

		renderer = Video.Renderer.create (window, -1,
            Video.RendererFlags.ACCELERATED | Video.RendererFlags.PRESENTVSYNC);

		window.show ();
		assert (renderer != null);
    }

    private void draw () {
    	int w;
    	int h;
    	window.get_size(out w, out h);
        int16 x = (int16) rand.int_range (0, w);
        int16 y = (int16) rand.int_range (0, h);
        int16 radius = (int16) rand.int_range (0, 100);
        uint32 color = rand.next_int ();

        Circle.fill_color (this.renderer, x, y, radius, color);
        Circle.outline_color_aa (this.renderer, x, y, radius, color);

        renderer.present();
    }

    private void process_events () {
        Event event;
        while (Event.poll (out event) == 1) {
            switch (event.type) {
            case EventType.QUIT:
                this.done = true;
                break;
            case EventType.KEYDOWN:
                this.on_keyboard_event (event.key);
                break;
            }
        }
    }

    private void on_keyboard_event (KeyboardEvent event) {
        if (is_alt_enter (event.keysym)) {
            window.set_fullscreen(0);
        }
    }

    private static bool is_alt_enter (Input.Key key) {
        return ((key.mod & Input.Keymod.LALT)!=0)
            && (key.sym == Input.Keycode.RETURN
                    || key.sym == Input.Keycode.KP_ENTER);
    }
}

public class Application : Object {

    private static bool verbose = false;
    private static bool version = false;
    private static string cfgfile = null;

    private const GLib.OptionEntry[] options = {{
        "config", 'c', 0, OptionArg.STRING, ref cfgfile,
        "Use the given configuration file.", null
    },{
        "verbose", 'v', 0, OptionArg.NONE, ref verbose,
        "Provide verbose debugging output.", null
    },{
        "version", 'V', 0, OptionArg.NONE, ref version,
        "Display version number.", null
    },{
        null
    }};

    public static int main (string[] args) {

        try {
            var opt_context = new OptionContext (Util.PACKAGE_NAME);
            opt_context.set_help_enabled (true);
            opt_context.add_main_entries (options, null);
            opt_context.parse (ref args);
        } catch (OptionError e) {
            stdout.printf ("error: %s\n", e.message);
            stdout.printf ("Run '%s --help' for a full list of command line options.\n", args[0]);
            return 0;
        }

        if (version) {
            stdout.printf ("%s\n", Util.PACKAGE_VERSION);
            return 0;
        }

        if (cfgfile == null) {
            cfgfile = Path.build_filename (Util.DATADIR, "elements.xml");
        }

        SDL.init (SDL.InitFlag.EVERYTHING | SDLImage.InitFlags.ALL);

        var window = new ApplicationWindow ();
        window.run ();

        SDL.quit ();

        return 0;
    }
}
