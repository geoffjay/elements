using Config;
using SDL;
using SDLGraphics;

public class ApplicationWindow : Object {

    private const int SCREEN_WIDTH = 640;
    private const int SCREEN_HEIGHT = 480;
    private const int SCREEN_BPP = 32;
    private const int DELAY = 10;

    private unowned SDL.Screen screen;
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
        uint32 video_flags = SurfaceFlag.DOUBLEBUF
                           | SurfaceFlag.HWACCEL
                           | SurfaceFlag.HWSURFACE;

        this.screen = Screen.set_video_mode (SCREEN_WIDTH, SCREEN_HEIGHT,
                                             SCREEN_BPP, video_flags);
        if (this.screen == null) {
            stderr.printf ("Could not set video mode.\n");
        }

        SDL.WindowManager.set_caption ("Vala SDL Demo", "");
    }

    private void draw () {
        int16 x = (int16) rand.int_range (0, screen.w);
        int16 y = (int16) rand.int_range (0, screen.h);
        int16 radius = (int16) rand.int_range (0, 100);
        uint32 color = rand.next_int ();

        Circle.fill_color (this.screen, x, y, radius, color);
        Circle.outline_color_aa (this.screen, x, y, radius, color);

        this.screen.flip ();
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
            WindowManager.toggle_fullscreen (screen);
        }
    }

    private static bool is_alt_enter (Key key) {
        return ((key.mod & KeyModifier.LALT)!=0)
            && (key.sym == KeySymbol.RETURN
                    || key.sym == KeySymbol.KP_ENTER);
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
            var opt_context = new OptionContext (PACKAGE_NAME);
            opt_context.set_help_enabled (true);
            opt_context.add_main_entries (options, null);
            opt_context.parse (ref args);
        } catch (OptionError e) {
            stdout.printf ("error: %s\n", e.message);
            stdout.printf ("Run '%s --help' for a full list of command line options.\n", args[0]);
            return 0;
        }

        if (version) {
            stdout.printf ("%s\n", PACKAGE_VERSION);
        } else {
            if (cfgfile == null) {
                cfgfile = Path.build_filename (DATADIR, "elements.xml");
            }

            SDL.init (InitFlag.VIDEO);

            var window = new ApplicationWindow ();
            window.run ();

            SDL.quit ();
        }

        return 0;
    }
}
