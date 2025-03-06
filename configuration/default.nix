{lib, ...}: {
  theme = "catppuccin_mocha";

  editor = {
    default-line-ending = "native";
    insert-final-newline = true;

    # Color
    color-modes = true;
    true-color = true;

    # Completion
    auto-completion = true;
    completion-replace = true;
    completion-timeout = 150;
    completion-trigger-len = 1;
    preview-completion-insert = true;

    # Formatting
    auto-format = true;

    # Scrolling
    scrolloff = 0;
    scroll-lines = 3;

    # Mouse
    mouse = false;
    middle-click-paste = false;

    # Numbers
    line-number = "absolute";

    # Cursor
    cursorline = true;
    cursor-shape = {
      insert = "bar";
      normal = "block";
      select = "block";
    };
    cursorcolumn = false;

    idle-timeout = 100;

    auto-info = true;

    undercurl = false;

    rulers = [120];

    text-width = 80;

    smart-tab = {
      enable = true;
      supersede-menu = false;
    };

    soft-wrap = {
      enable = false;
      max-indent-retain = 0;
      max-wrap = 25;
      wrap-at-text-width = false;
      wrap-indicator = "";
    };

    popup-border = "all";

    bufferline = "always";

    gutters = ["diagnostics" "spacer" "line-numbers" "spacer" "diff"];

    statusline = {
      left = ["mode" "separator" "version-control" "separator" "file-name" "separator" "spinner" "separator" "diagnostics"];
      center = [];
      right = ["selections" "file-encoding" "file-line-ending" "file-type" "position"];
      separator = " ";
      mode = {
        normal = "NORMAL";
        insert = "INSERT";
        select = "SELECT";
      };
    };

    auto-pairs = true;

    file-picker = {
      hidden = false;
      git-ignore = false;
      git-global = false;
      git-exclude = false;
      deduplicate-links = true;
    };

    indent-guides = {
      character = "▏";
      render = true;
      skip-levels = 1;
    };
    indent-heuristic = "hybrid";

    lsp = {
      auto-signature-help = true;
      display-inlay-hints = true;
      display-messages = true;
      display-signature-help-docs = true;
      goto-reference-include-declaration = true;
      snippets = false;
    };

    inline-diagnostics = {
      cursor-line = "hint";
      other-lines = "disable";
    };
    end-of-line-diagnostics = "hint";

    jump-label-alphabet = "abcdefghijklmnopqrstuvwxyz";

    whitespace = {
      render = {
        newline = "none";
        nbsp = "none";
        nnbsp = "none";
        space = "all";
        tab = "all";
        tabpad = "none";
      };
      characters = {
        newline = "⏎";
        nbsp = "⍽";
        nnbsp = "␣";
        space = " ";
        tab = "→";
        tabpad = " ";
      };
    };
  };

  keys = let
    navigationBindings = let
      trimSelections = keybind: [keybind "trim_selections"];
    in
      type: {
        w = "${type}_next_word_start";
        W = "${type}_next_long_word_start";

        e = trimSelections "${type}_next_word_end";
        E = trimSelections "${type}_next_long_word_end";

        b =
          if type == "move"
          then trimSelections "${type}_prev_word_start"
          else "${type}_prev_word_start";
        B =
          if type == "move"
          then trimSelections "${type}_prev_long_word_start"
          else "${type}_prev_long_word_start";

        tab = "${type}_parent_node_end";
        S-tab = "${type}_parent_node_start";
      };

    arrowBindings = type: {
      up = "${type}_line_up";
      down = "${type}_line_down";
      left = "${type}_char_left";
      right = "${type}_char_right";
    };

    disableModelessNavigationBindings = {
      up = "no_op";
      down = "no_op";
      left = "no_op";
      right = "no_op";
      pageup = "no_op";
      pagedown = "no_op";
      home = "no_op";
      end = "no_op";
    };

    moveLineBindings = {
      A-down = [
        "extend_to_line_bounds"
        "delete_selection"
        "paste_after"
      ];
      A-up = [
        "extend_to_line_bounds"
        "delete_selection"
        "move_line_up"
        "paste_before"
      ];
    };

    duplicateLineBindings = {
      S-A-down = [
        "extend_to_line_bounds"
        "yank"
        "open_below"
        "normal_mode"
        "replace_with_yanked"
        "collapse_selection"
      ];
      S-A-up = [
        "extend_to_line_bounds"
        "yank"
        "open_above"
        "normal_mode"
        "replace_with_yanked"
        "collapse_selection"
      ];
    };
  in {
    normal =
      (navigationBindings "move")
      // moveLineBindings
      // duplicateLineBindings
      // (arrowBindings "move")
      // {
        i = ["insert_mode" "collapse_selection"];
        v = "select_mode";

        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        g.g = "goto_file_start";
        G = "goto_last_line";

        "{" = "goto_next_paragraph";
        "}" = "goto_prev_paragraph";

        esc = ["collapse_selection" "keep_primary_selection"];
        "ret" = ["move_line_down" "goto_first_nonwhitespace"];

        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";

        x = "delete_char_forward";
        d = {
          d = ["kill_to_line_end" "kill_to_line_start"];
          w = "delete_word_forward";
        };
        D = "delete_char_backward";

        p = ":clipboard-paste-after";
        Cmd-v = ":clipboard-paste-after";
        y = ":clipboard-yank";
        Cmd-c = ":clipboard-yank";

        C-h = "jump_view_left";
        C-j = "jump_view_down";
        C-k = "jump_view_up";
        C-l = "jump_view_right";

        g.c = {
          c = "toggle_line_comments";
          b = "toggle_block_comments";
        };

        space = {
          f = {
            f = "file_picker";
            g = "global_search";
            s = "symbol_picker";
            j = "jumplist_picker";
            b = "buffer_picker";
          };
          c = {
            a = "code_action";
            d = "diagnostics_picker";
            s = "signature_help";
            f = ":format";
          };
          t = {
            t = "goto_definition";
            i = "goto_implementation";
            r = "goto_reference";
            d = "goto_type_definition";
          };
          b = {
            n = "goto_next_buffer";
            p = "goto_previous_buffer";
            d = ":buffer-close!";
            o = ":buffer-close-others!";
          };

          Q = ":quit!";
          W = ":write!";
        };

        "C-tab" = "goto_next_buffer";
        "C-S-tab" = "goto_previous_buffer";

        Cmd-w = ":buffer-close";
        Cmd-s = ":write!";
        Cmd-f = "global_search";
        Cmd-z = "undo";
        "Cmd-/" = "toggle_comments";
      };

    insert =
      disableModelessNavigationBindings
      // duplicateLineBindings
      // {
        Cmd-c = ["goto_line_start" "select_mode" "goto_line_end" ":clipboard-yank" "insert_mode"];
        Cmd-x = ["goto_line_start" "select_mode" "goto_line_end" ":clipboard-yank" "delete_selection" "insert_mode"];
        Cmd-v = ":clipboard-paste-before";
      };

    select =
      (navigationBindings "extend")
      // (arrowBindings "extend")
      // {
        "0" = "goto_line_start";
        G = "goto_file_end";

        "{" = ["extend_to_line_bounds" "goto_prev_paragraph"];
        "}" = ["extend_to_line_bounds" "goto_next_paragraph"];

        del = "delete_selection_noyank";

        "A-x" = "extend_to_line_bounds";
        X = ["extend_line_up" "extend_to_line_bounds"];
      };
  };
}
