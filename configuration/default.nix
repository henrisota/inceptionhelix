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
      right = ["selections" "position" "file-encoding" "file-line-ending" "file-type"];
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
      git-ignore = true;
      git-global = true;
      git-exclude = true;
      deduplicate-links = true;
    };

    indent-guides = {
      character = "▏";
      rainbow-option = "none";
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
    commonBindings = {
      esc = ["collapse_selection" "keep_primary_selection"];
    };

    navigationBindings = {
      "0" = "goto_line_start";
      "$" = "goto_line_end";
      "^" = "goto_first_nonwhitespace";
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
    insert =
      commonBindings
      // disableModelessNavigationBindings
      // duplicateLineBindings;

    normal =
      commonBindings
      // navigationBindings
      // {
        # Mode
        a = ["append_mode" "collapse_selection"];
        i = ["insert_mode" "collapse_selection"];
        v = ["select_mode" "collapse_selection"];

        # Navigation
        g.g = "goto_file_start";
        G = "goto_last_line";
        ret = ["move_line_down" "goto_first_nonwhitespace"];
        "%" = "match_brackets";

        w = ["move_next_word_start" "move_char_right" "collapse_selection"];
        W = ["move_next_long_word_start" "move_char_right" "collapse_selection"];
        e = ["move_next_word_end" "collapse_selection"];
        E = ["move_next_long_word_end" "collapse_selection"];
        b = ["move_prev_word_start" "collapse_selection"];
        B = ["move_prev_long_word_start" "collapse_selection"];

        "{" = "goto_next_paragraph";
        "}" = "goto_prev_paragraph";

        tab = "move_parent_node_end";
        S-tab = "move_parent_node_start";

        C-f = ["page_cursor_down" "align_view_center"];
        C-b = ["page_cursor_up" "align_view_center"];
        C-d = ["page_cursor_half_down" "align_view_center"];
        C-u = ["page_cursor_half_up" "align_view_center"];

        # Modification
        d = {
          d = ["extend_to_line_bounds" "delete_selection"];
          s = "surround_delete";
          w = "delete_word_forward";
        };
        D = "delete_char_backward";
        p = "paste_clipboard_after";
        P = "paste_clipboard_before";
        y = "yank_to_clipboard";
        x = "delete_selection_noyank";
        del = "delete_selection_noyank";

        C-h = "jump_view_left";
        C-j = "jump_view_down";
        C-k = "jump_view_up";
        C-l = "jump_view_right";

        space = {
          A-c = "no_op";
          a = "no_op";
          C = "no_op";
          d = "no_op";
          D = "no_op";
          E = "no_op";
          G = "no_op";
          h = "no_op";
          j = "no_op";
          k = "no_op";
          p = "no_op";
          P = "no_op";
          s = "no_op";
          S = "no_op";
          y = "no_op";
          Y = "no_op";
          "'" = "no_op";

          space = "file_picker";
          F = ":format";
          q = ":quit-all";
          r = "rename_symbol";
          R = ":reload-all";
          w = ":write-all!";
          "/" = "global_search";
          "?" = "command_palette";

          b = {
            d = ":buffer-close!";
            o = ":buffer-close-others!";
          };
          c = {
            a = "code_action";
            d = "diagnostics_picker";
          };
          f = {
            b = "buffer_picker";
            d = "diagnostics_picker";
            D = "workspace_diagnostics_picker";
            f = "file_picker";
            g = "global_search";
            j = "jumplist_picker";
            s = "symbol_picker";
            S = "workspace_symbol_picker";
          };
          g = {
            d = "goto_definition";
            i = "goto_implementation";
            r = "goto_reference";
            t = "goto_type_definition";
          };
        };

        "C-tab" = "goto_next_buffer";
        "C-S-tab" = "goto_previous_buffer";

        Cmd-f = "search";
        Cmd-F = "global_search"; # TODO: Find out why binding does not trigger command
        Cmd-n = ":new";
        Cmd-s = ":write!";
        Cmd-w = ":buffer-close";
        Cmd-z = "undo";
        "Cmd-/" = "toggle_comments";
      }
      // moveLineBindings
      // duplicateLineBindings;

    select =
      commonBindings
      // navigationBindings
      // {
        # Navigation
        G = "goto_file_end";

        w = "extend_next_word_start";
        W = "extend_next_long_word_start";
        e = "extend_next_word_end";
        E = "extend_next_long_word_end";
        b = "extend_prev_word_start";
        B = "extend_prev_long_word_start";

        "{" = ["extend_to_line_bounds" "goto_prev_paragraph"];
        "}" = ["extend_to_line_bounds" "goto_next_paragraph"];

        tab = "extend_parent_node_end";
        S-tab = "extend_parent_node_start";

        # Selection
        a = "select_textobject_around";
        i = "select_textobject_inner";
        j = ["extend_line_down" "extend_to_line_bounds"];
        k = ["extend_line_up" "extend_to_line_bounds"];
        A-x = "extend_to_line_bounds";
        X = ["extend_line_up" "extend_to_line_bounds"];

        # Modification
        d = ["yank_main_selection_to_clipboard" "delete_selection"];
        p = "replace_selections_with_clipboard";
        P = "paste_clipboard_before";
        y = ["yank_main_selection_to_clipboard" "normal_mode" "flip_selections" "collapse_selection"];
        Y = ["extend_to_line_bounds" "yank_main_selection_to_clipboard" "goto_line_start" "collapse_selection" "normal_mode"];
        x = ["yank_main_selection_to_clipboard" "delete_selection"];
        del = "delete_selection_noyank";

        S = "surround_add";
      }
      // disableModelessNavigationBindings;
  };
}
