;;; ============================================================
;;; Overlay for Disk Copy - $D000 - $F1FF (file 3/4)
;;;
;;; Compiled as part of desktop.s
;;; ============================================================

.proc disk_copy_overlay3
        .org $D000

.macro MGTK_RELAY_CALL2 call, params
    .if .paramcount > 1
        param_call MGTK_RELAY2, call, params
    .else
        param_call MGTK_RELAY2, call, 0
    .endif
.endmacro

;;; ============================================================

        ASSERT_ADDRESS $D000, "Entry point"

start:
        jmp     init

;;; ============================================================
;;; Resources

pencopy:        .byte   0
penOR:          .byte   1
penXOR:         .byte   2
penBIC:         .byte   3
notpencopy:     .byte   4
notpenOR:       .byte   5
notpenXOR:      .byte   6
notpenBIC:      .byte   7

stack_stash:  .byte   0

.params hilitemenu_params
menu_id   := * + 0
.endparams
.params menuselect_params
menu_id   := * + 0
menu_item := * + 1
.endparams
.params menukey_params
menu_id   := * + 0
menu_item := * + 1
which_key := * + 2
key_mods  := * + 3
.endparams
        .res    4, 0



        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0

;;; ============================================================
;;; Menu definition

        kMenuIdApple = 1
        kMenuIdFile = 2
        kMenuIdFacilities = 3

menu_definition:
        DEFINE_MENU_BAR 3
@items: DEFINE_MENU_BAR_ITEM kMenuIdApple, label_apple, menu_apple
        DEFINE_MENU_BAR_ITEM kMenuIdFile, label_file, menu_file
        DEFINE_MENU_BAR_ITEM kMenuIdFacilities, label_facilities, menu_facilities
        ASSERT_RECORD_TABLE_SIZE @items, 3, .sizeof(MGTK::MenuBarItem)

menu_apple:
        DEFINE_MENU 5
@items: DEFINE_MENU_ITEM label_desktop
        DEFINE_MENU_ITEM label_blank
        DEFINE_MENU_ITEM label_copyright1
        DEFINE_MENU_ITEM label_copyright2
        DEFINE_MENU_ITEM label_rights
        ASSERT_RECORD_TABLE_SIZE @items, 5, .sizeof(MGTK::MenuItem)

menu_file:
        DEFINE_MENU 1
@items: DEFINE_MENU_ITEM label_quit, 'Q', 'q'
        ASSERT_RECORD_TABLE_SIZE @items, 1, .sizeof(MGTK::MenuItem)

label_apple:
        PASCAL_STRING kGlyphSolidApple ; do not localize

menu_facilities:
        DEFINE_MENU 2
@items: DEFINE_MENU_ITEM label_quick_copy
        DEFINE_MENU_ITEM label_disk_copy
        ASSERT_RECORD_TABLE_SIZE @items, 2, .sizeof(MGTK::MenuItem)

label_file:
        PASCAL_STRING "File"    ; menu bar item
label_facilities:
        PASCAL_STRING "Facilities" ; menu bar item

label_desktop:
        PASCAL_STRING .sprintf("%s Version %d.%d", kDeskTopProductName, ::kDeskTopVersionMajor, ::kDeskTopVersionMinor) ; menu item

label_blank:
        PASCAL_STRING " "       ; do not localize
label_copyright1:
        PASCAL_STRING "Copyright Apple Computer Inc., 1986" ; menu item
label_copyright2:
        PASCAL_STRING "Copyright Version Soft, 1985 - 1986" ; menu item
label_rights:
        PASCAL_STRING "All Rights reserved" ; menu item

label_quit:
        PASCAL_STRING "Quit"    ; menu item

label_quick_copy:
        PASCAL_STRING "Quick Copy" ; menu item

label_disk_copy:
        PASCAL_STRING "Disk Copy" ; menu item

;;; ============================================================

.params disablemenu_params
menu_id:        .byte   3
disable:        .byte   0
.endparams

.params checkitem_params
menu_id:        .byte   3
menu_item:      .byte   0
check:          .byte   0
.endparams

event_params := *
        event_kind := event_params + 0
        ;;  if kind is key_down
        event_key := event_params + 1
        event_modifiers := event_params + 2
        ;;  if kind is no_event, button_down/up, drag, or apple_key:
        event_coords := event_params + 1
        event_xcoord := event_params + 1
        event_ycoord := event_params + 3
        ;;  if kind is update:
        event_window_id := event_params + 1

screentowindow_params := *
        screentowindow_window_id := screentowindow_params + 0
        screentowindow_screenx := screentowindow_params + 1
        screentowindow_screeny := screentowindow_params + 3
        screentowindow_windowx := screentowindow_params + 5
        screentowindow_windowy := screentowindow_params + 7

findwindow_params := * + 1    ; offset to x/y overlap event_params x/y
        findwindow_mousex := findwindow_params + 0
        findwindow_mousey := findwindow_params + 2
        findwindow_which_area := findwindow_params + 4
        findwindow_window_id := findwindow_params + 5


        .byte   0
        .byte   0
LD12F:  .byte   0
        .byte   0
        .byte   0
        .byte   0

LD133:  .byte   0

        .byte   0
        .byte   0
        .byte   0

grafport:  .res .sizeof(MGTK::GrafPort), 0

.params getwinport_params
window_id:      .byte   0
port:           .addr   grafport_win
.endparams

grafport_win:  .res    .sizeof(MGTK::GrafPort), 0

        ;; Rest of a winfo???
        .byte   $06, $EA, 0, 0, 0, 0, $88, 0, $08, 0, $08

kDialogWidth    = 500
kDialogHeight   = 150

.params winfo_dialog
window_id:      .byte   1
options:        .byte   MGTK::Option::dialog_box
title:          .addr   0
hscroll:        .byte   MGTK::Scroll::option_none
vscroll:        .byte   MGTK::Scroll::option_none
hthumbmax:      .byte   0
hthumbpos:      .byte   0
vthumbmax:      .byte   0
vthumbpos:      .byte   0
status:         .byte   0
reserved:       .byte   0
mincontwidth:   .word   150
mincontlength:  .word   50
maxcontwidth:   .word   500
maxcontlength:  .word   140
port:
viewloc:        DEFINE_POINT 25, 20
mapbits:        .addr   MGTK::screen_mapbits
mapwidth:       .byte   MGTK::screen_mapwidth
reserved2:      .byte   0
cliprect:       DEFINE_RECT 0, 0, kDialogWidth, kDialogHeight
penpattern:     .res    8, $FF
colormasks:     .byte   MGTK::colormask_and, MGTK::colormask_or
penloc:         DEFINE_POINT 0, 0
penwidth:       .byte   1
penheight:      .byte   1
penmode:        .byte   0
textbg:         .byte   MGTK::textbg_white
fontptr:        .addr   DEFAULT_FONT
nextwinfo:      .addr   0
.endparams

.params winfo_drive_select
window_id:      .byte   $02
options:        .byte   MGTK::Option::dialog_box
title:          .addr   0
hscroll:        .byte   MGTK::Scroll::option_none
vscroll:        .byte   MGTK::Scroll::option_present
hthumbmax:      .byte   0
hthumbpos:      .byte   0
vthumbmax:      .byte   3
vthumbpos:      .byte   0
status:         .byte   0
reserved:       .byte   0
mincontwidth:   .word   100
mincontlength:  .word   50
maxcontwidth:   .word   150
maxcontlength:  .word   150
port:
viewloc:        DEFINE_POINT 45, 50
mapbits:        .addr   MGTK::screen_mapbits
mapwidth:       .byte   MGTK::screen_mapwidth
reserved2:      .byte   0
cliprect:       DEFINE_RECT 0, 0, 150, 70
penpattern:     .res    8, $FF
colormasks:     .byte   MGTK::colormask_and, MGTK::colormask_or
penloc:         DEFINE_POINT 0, 0
penwidth:       .byte   1
penheight:      .byte   1
penmode:        .byte   0
textbg:         .byte   MGTK::textbg_white
fontptr:        .addr   DEFAULT_FONT
nextwinfo:      .addr   0
.endparams

rect_outer_frame:      DEFINE_RECT_INSET 4, 2, kDialogWidth, kDialogHeight
rect_inner_frame:      DEFINE_RECT_INSET 5, 3, kDialogWidth, kDialogHeight
rect_D211:      DEFINE_RECT 6, 20, 494, 102
rect_D219:      DEFINE_RECT 6, 103, 494, 145

rect_ok_button:      DEFINE_RECT_SZ 350, 90, kButtonWidth, kButtonHeight
point_ok_label:     DEFINE_POINT 355, 100
str_ok_label:
        PASCAL_STRING "OK            \x0D" ; button label

;;; Label positions
point_title:     DEFINE_POINT 0, 15
str_disk_copy_padded:
        PASCAL_STRING "     Disk Copy    " ; dialog title
str_quick_copy_padded:
        PASCAL_STRING "Quick Copy      " ; dialog title

rect_D255:      DEFINE_RECT 270, 38, 420, 46

rect_read_drive:      DEFINE_RECT_SZ 210, 90, kButtonWidth, kButtonHeight
point_read_drive:     DEFINE_POINT 215, 100
str_read_drive:
        PASCAL_STRING "Read Drive   D" ; button label

point_slot_drive_name:     DEFINE_POINT 20, 28
str_slot_drive_name:
        PASCAL_STRING "Slot, Drive, Name" ; dialog label

point_select_source:     DEFINE_POINT 270, 46
str_select_source:
        PASCAL_STRING "Select source disk" ; dialog label
str_select_destination:
        PASCAL_STRING "Select destination disk" ; dialog label

point_formatting:     DEFINE_POINT 210, 68
str_formatting:
        PASCAL_STRING "Formatting the disk ...."

point_writing:     DEFINE_POINT 210, 68
str_writing:
        PASCAL_STRING "Writing ....   "

point_reading:     DEFINE_POINT 210, 68
str_reading:
        PASCAL_STRING "Reading ....    "

str_unknown:
        PASCAL_STRING "Unknown"
str_select_quit:
        PASCAL_STRING {"Select Quit from the file menu (",kGlyphOpenApple,"Q) to go back to the DeskTop"} ; dialog label

bg_black:
        .byte   0
bg_white:
        .byte   $7F

rect_D35B: DEFINE_RECT 0, 0, 150, 0, rect_D35B


current_drive_selection:        ; $FF if no selection
        .byte   0
        .byte   0
        .byte   0
        .byte   0
LD367:  .byte   0
LD368:  .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0

point_D36D:  DEFINE_POINT 0, 0, point_D36D
        .byte   0
        .byte   0
        .byte   $47
        .byte   0

num_drives:
        .byte   0

LD376:  .byte   0

kMaxNumDrives = 8

drive_name_table:
        .res    kMaxNumDrives * 16, 0
drive_unitnum_table:
        .res    kMaxNumDrives, 0
LD3FF:  .res    kMaxNumDrives, 0
block_count_table:
        .res    kMaxNumDrives * 2, 0

source_drive_index:  .byte   0
dest_drive_index:  .byte   0

str_d:  PASCAL_STRING 0         ; do not localize
str_s:  PASCAL_STRING 0         ; do not localize
LD41D:  .byte   0
LD41E:  .byte   0
LD41F:  .byte   0
LD420:  .byte   0
LD421:  .word   0
LD423:  .byte   0
LD424:  .word   0
LD426:  .byte   0
LD427:  .word   0
LD429:  .byte   0

rect_D42A:      DEFINE_RECT 18, 20, 490, 88
rect_D432:      DEFINE_RECT 19, 29, 195, 101

LD43A:  .res 18, 0
LD44C:  .byte   0
LD44D:  .byte   0
LD44E:  .byte   0
        .byte   0
        .byte   0
quick_copy_flag:  .byte   0
        .byte   1, 0

str_2_spaces:   PASCAL_STRING "  "      ; do not localize
str_number:     PASCAL_STRING "       " ; filled in by string_to_number - do not localize

;;; Label positions
point_blocks_read:     DEFINE_POINT 300, 125
point_blocks_written:     DEFINE_POINT 300, 135
point_source:     DEFINE_POINT 300, 115
point_source2:     DEFINE_POINT 40, 125
point_slot_drive:     DEFINE_POINT 110, 125
point_destination:     DEFINE_POINT 40, 135
point_slot_drive2:     DEFINE_POINT 110, 135
point_disk_copy:     DEFINE_POINT 40, 115
point_select_quit:     DEFINE_POINT 20, 145
rect_D483:      DEFINE_RECT 20, 136, 400, 145
point_escape_stop_copy:     DEFINE_POINT 300, 145
point_error_writing:     DEFINE_POINT 40, 100
point_error_reading:     DEFINE_POINT 40, 90

str_blocks_read:
        PASCAL_STRING "Blocks Read: "
str_blocks_written:
        PASCAL_STRING "Blocks Written: "
str_blocks_to_transfer:
        PASCAL_STRING "Blocks to transfer: "
str_source:
        PASCAL_STRING "Source "
str_destination:
        PASCAL_STRING "Destination "
str_slot:
        PASCAL_STRING "Slot "
str_drive:
        PASCAL_STRING "  Drive "

str_dos33_s_d:
        PASCAL_STRING "DOS 3.3 S#, D# "
        kStrDOS33SlotOffset = 10
        kStrDOS33DriveOffset = 14

str_dos33_disk_copy:
        PASCAL_STRING "DOS 3.3 disk copy"

str_pascal_disk_copy:
        PASCAL_STRING "Pascal disk copy"

str_prodos_disk_copy:
        PASCAL_STRING "ProDOS disk copy"

str_escape_stop_copy:
        PASCAL_STRING " ESC stop the copy"

str_error_writing:
        PASCAL_STRING "Error when writing block "

str_error_reading:
        PASCAL_STRING "Error when reading block "

;;; ============================================================

        ;; cursor definition - pointer
pointer_cursor:
        .byte   PX(%0000000),PX(%0000000)
        .byte   PX(%0100000),PX(%0000000)
        .byte   PX(%0110000),PX(%0000000)
        .byte   PX(%0111000),PX(%0000000)
        .byte   PX(%0111100),PX(%0000000)
        .byte   PX(%0111110),PX(%0000000)
        .byte   PX(%0111111),PX(%0000000)
        .byte   PX(%0101100),PX(%0000000)
        .byte   PX(%0000110),PX(%0000000)
        .byte   PX(%0000110),PX(%0000000)
        .byte   PX(%0000011),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000)
        .byte   PX(%1100000),PX(%0000000)
        .byte   PX(%1110000),PX(%0000000)
        .byte   PX(%1111000),PX(%0000000)
        .byte   PX(%1111100),PX(%0000000)
        .byte   PX(%1111110),PX(%0000000)
        .byte   PX(%1111111),PX(%0000000)
        .byte   PX(%1111111),PX(%1000000)
        .byte   PX(%1111111),PX(%0000000)
        .byte   PX(%0001111),PX(%0000000)
        .byte   PX(%0001111),PX(%0000000)
        .byte   PX(%0000111),PX(%1000000)
        .byte   PX(%0000111),PX(%1000000)
        .byte   1,1

        ;; Cursor definition - watch
watch_cursor:
        .byte   PX(%0000000),PX(%0000000)
        .byte   PX(%0011111),PX(%1100000)
        .byte   PX(%0011111),PX(%1100000)
        .byte   PX(%0100000),PX(%0010000)
        .byte   PX(%0100001),PX(%0010000)
        .byte   PX(%0100110),PX(%0011000)
        .byte   PX(%0100000),PX(%0010000)
        .byte   PX(%0100000),PX(%0010000)
        .byte   PX(%0011111),PX(%1100000)
        .byte   PX(%0011111),PX(%1100000)
        .byte   PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000)
        .byte   PX(%0011111),PX(%1100000)
        .byte   PX(%0111111),PX(%1110000)
        .byte   PX(%0111111),PX(%1110000)
        .byte   PX(%1111111),PX(%1111000)
        .byte   PX(%1111111),PX(%1111000)
        .byte   PX(%1111111),PX(%1111100)
        .byte   PX(%1111111),PX(%1111000)
        .byte   PX(%1111111),PX(%1111000)
        .byte   PX(%0111111),PX(%1110000)
        .byte   PX(%0111111),PX(%1110000)
        .byte   PX(%0011111),PX(%1100000)
        .byte   PX(%0000000),PX(%0000000)
        .byte   5, 5

;;; ============================================================

LD5E0:  .byte   0

init:   jsr     remove_ram_disk
        MGTK_RELAY_CALL2 MGTK::SetMenu, menu_definition
        jsr     set_cursor_pointer
        copy    #1, checkitem_params::menu_item
        copy    #1, checkitem_params::check
        MGTK_RELAY_CALL2 MGTK::CheckItem, checkitem_params
        copy    #1, disablemenu_params::disable
        MGTK_RELAY_CALL2 MGTK::DisableMenu, disablemenu_params
        lda     #$00
        sta     quick_copy_flag
        sta     LD5E0
        jsr     open_dialog
LD61C:  lda     #$00
        sta     LD367
        sta     LD368
        sta     LD44C
        lda     #$FF
        sta     current_drive_selection
        lda     #$81
        sta     LD44D
        copy    #0, disablemenu_params::disable
        MGTK_RELAY_CALL2 MGTK::DisableMenu, disablemenu_params
        lda     #1
        sta     checkitem_params::check
        MGTK_RELAY_CALL2 MGTK::CheckItem, checkitem_params
        jsr     draw_dialog
        MGTK_RELAY_CALL2 MGTK::OpenWindow, winfo_drive_select
        lda     #$00
        sta     LD429
        lda     #$FF
        sta     LD44C
        jsr     enumerate_devices

        lda     LD5E0
        bne     :+
        jsr     get_all_block_counts
:       jsr     draw_device_list_entries
        inc     LD5E0
LD674:  jsr     LD986
        bmi     LD674
        beq     LD687
        MGTK_RELAY_CALL2 MGTK::CloseWindow, winfo_drive_select
        jmp     LD61C

LD687:  lda     current_drive_selection
        bmi     LD674
        copy    #1, disablemenu_params::disable
        MGTK_RELAY_CALL2 MGTK::DisableMenu, disablemenu_params
        lda     current_drive_selection
        sta     source_drive_index
        lda     winfo_drive_select
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, winfo_drive_select::cliprect
        lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D255
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_select_source
        param_call DrawString, str_select_destination
        jsr     LE559
        jsr     LE2B1
LD6E6:  jsr     LD986
        bmi     LD6E6
        beq     LD6F9
        MGTK_RELAY_CALL2 MGTK::CloseWindow, winfo_drive_select
        jmp     LD61C

LD6F9:  lda     current_drive_selection
        bmi     LD6E6
        tax
        lda     LD3FF,x
        sta     dest_drive_index
        lda     #$00
        sta     LD44C
        lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D211
        MGTK_RELAY_CALL2 MGTK::CloseWindow, winfo_drive_select
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D432
LD734:  param_call show_alert_dialog, $0000 ; Insert Source
        beq     LD740
        jmp     LD61C

LD740:  lda     #$00
        sta     LD44D
        ldx     source_drive_index
        lda     drive_unitnum_table,x
        sta     disk_copy_overlay4_on_line_params2_unit_num
        jsr     disk_copy_overlay4_L1291
        beq     LD77E
        cmp     #ERR_NOT_PRODOS_VOLUME
        bne     LD763
        jsr     disk_copy_overlay4_L0D5F
        jsr     LE674
        jsr     LE559
        jmp     LD7AD

LD763:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D42A
        jmp     LD734

LD77E:  lda     $1300
        and     #$0F
        bne     LD798
        lda     $1301
        cmp     #ERR_NOT_PRODOS_VOLUME
        bne     LD763
        jsr     disk_copy_overlay4_L0D5F
        jsr     LE674
        jsr     LE559
        jmp     LD7AD

LD798:  lda     $1300
        and     #$0F
        sta     $1300
        param_call adjust_case, $1300
        jsr     LE674
        jsr     LE559
LD7AD:  lda     source_drive_index
        jsr     get_block_count
        jsr     LE5E1
        jsr     LE63F
        ldx     dest_drive_index
        lda     drive_unitnum_table,x
        tay
        ldx     #$00

        lda     #1              ; Insert Destination
        jsr     show_alert_dialog

        beq     LD7CC
        jmp     LD61C

LD7CC:  ldx     dest_drive_index
        lda     drive_unitnum_table,x
        sta     disk_copy_overlay4_on_line_params2_unit_num
        jsr     disk_copy_overlay4_L1291
        beq     LD7E1
        cmp     #ERR_NOT_PRODOS_VOLUME
        beq     LD7F2
        jmp     LD852

LD7E1:  lda     $1300
        and     #$0F
        bne     LD7F2
        lda     $1301
        cmp     #ERR_NOT_PRODOS_VOLUME
        beq     LD7F2
        jmp     LD852

LD7F2:
        ldx     dest_drive_index
        lda     drive_unitnum_table,x
        and     #$0F            ; low nibble of unit_num
        beq     LD817           ; Disk II

        lda     drive_unitnum_table,x
        jsr     disk_copy_overlay4_unit_number_to_driver_address
        bne     :+              ; if not firmware, skip these checks

        lda     #$00            ; point at $Cn00
        sta     $06
        ldy     #$FF            ; $CnFF
        lda     ($06),y
        beq     LD817           ; = $00 means 16-sector Disk II
        cmp     #$FF            ; = $FF means 13-sector Disk II
        beq     LD817
        ldy     #$FE            ; $CnFE
        lda     ($06),y
        and     #$08            ; bit 3 = The device supports formatting.
        bne     LD817
:       jmp     LD8A9

LD817:  lda     $1300
        and     #$0F
        bne     LD82C
        ldx     dest_drive_index
        lda     drive_unitnum_table,x
        and     #$F0
        tax
        lda     #$07
        jmp     LD83C

LD82C:  sta     $1300
        param_call adjust_case, $1300
        ldx     #$00
        ldy     #$13

        lda     #2              ; Confirm Erase
LD83C:  jsr     show_alert_dialog
        cmp     #$01
        beq     LD847
        cmp     #$02
        beq     LD84A
LD847:  jmp     LD61C

LD84A:  lda     quick_copy_flag
        bne     LD852
        jmp     LD8A9

LD852:  ldx     dest_drive_index
        lda     drive_unitnum_table,x
        and     #$0F            ; low nibble of unit_num
        beq     LD87C           ; Disk II
        lda     drive_unitnum_table,x
        jsr     disk_copy_overlay4_unit_number_to_driver_address
        bne     :+              ; if not not firmware, skip these checks

        lda     #$00            ; point at $Cn00
        sta     $06
        ldy     #$FE            ; $CnFE
        lda     ($06),y
        and     #$08            ; bit 3 = The device supports formatting.
        bne     LD87C
        ldy     #$FF            ; low byte of driver address
        lda     ($06),y
        beq     LD87C           ; $00 = 16-sector Disk II
        cmp     #$FF            ; $FF = 13-sector Disk II
        beq     LD87C

:       lda     #3              ; Destination format failed
        jsr     show_alert_dialog
        jmp     LD61C

LD87C:  MGTK_RELAY_CALL2 MGTK::MoveTo, point_formatting
        param_call DrawString, str_formatting
        jsr     disk_copy_overlay4_format_device
        bcc     LD8A9
        cmp     #ERR_WRITE_PROTECTED
        beq     LD89F

        lda     #4              ; Format error
        jsr     show_alert_dialog
        beq     LD852
        jmp     LD61C

LD89F:  lda     #5              ; Destination protected
        jsr     show_alert_dialog
        beq     LD852
        jmp     LD61C

LD8A9:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D211
        lda     source_drive_index
        cmp     dest_drive_index
        bne     LD8DF
        tax
        lda     drive_unitnum_table,x
        pha
        jsr     disk_copy_overlay4_eject_disk
        pla
        tay
        ldx     #$80
        lda     #0              ; Insert source
        jsr     show_alert_dialog
        beq     LD8DF
        jmp     LD61C

LD8DF:  jsr     disk_copy_overlay4_L0DB5
        lda     #$00
        sta     LD421
        sta     LD421+1
        lda     #$07
        sta     LD423
        jsr     LE4BF
        jsr     LE4EC
        jsr     LE507
        jsr     LE694
LD8FB:  jsr     LE4A8
        lda     #$00
        jsr     disk_copy_overlay4_L0ED7
        cmp     #$01
        beq     LD97A
        jsr     LE4EC
        lda     source_drive_index
        cmp     dest_drive_index
        bne     LD928
        tax
        lda     drive_unitnum_table,x
        pha
        jsr     disk_copy_overlay4_eject_disk
        pla
        tay
        ldx     #$80
        lda     #1              ; Insert destination
        jsr     show_alert_dialog
        beq     LD928
        jmp     LD61C

LD928:  jsr     LE491
        lda     #$80
        jsr     disk_copy_overlay4_L0ED7
        bmi     LD955
        bne     LD97A
        jsr     LE507
        lda     source_drive_index
        cmp     dest_drive_index
        bne     LD8FB
        tax
        lda     drive_unitnum_table,x
        pha
        jsr     disk_copy_overlay4_eject_disk
        pla
        tay
        ldx     #$80
        lda     #0              ; Insert source
        jsr     show_alert_dialog
        beq     LD8FB
        jmp     LD61C

LD955:  jsr     LE507
        jsr     disk_copy_overlay4_L10FB
        ldx     source_drive_index
        lda     drive_unitnum_table,x
        jsr     disk_copy_overlay4_eject_disk
        ldx     dest_drive_index
        cpx     source_drive_index
        beq     :+
        lda     drive_unitnum_table,x
        jsr     disk_copy_overlay4_eject_disk
:       lda     #9              ; Copy success
        jsr     show_alert_dialog
        jmp     LD61C

LD97A:  jsr     disk_copy_overlay4_L10FB
        lda     #10             ; Copy failed
        jsr     show_alert_dialog
        jmp     LD61C

        .byte   0
LD986:  MGTK_RELAY_CALL2 MGTK::InitPort, grafport
        MGTK_RELAY_CALL2 MGTK::SetPort, grafport
LD998:  bit     LD368
        bpl     :+
        dec     LD367
        bne     :+
        lda     #$00
        sta     LD368
:       MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_down
        bne     LD9BA
        jmp     handle_button_down

LD9BA:  cmp     #MGTK::EventKind::key_down
        bne     LD998
        jmp     LD9D5

menu_command_table:
        ;; Apple menu
        .addr   disk_copy_overlay4_noop
        .addr   disk_copy_overlay4_noop
        .addr   disk_copy_overlay4_noop
        .addr   disk_copy_overlay4_noop
        .addr   disk_copy_overlay4_noop
        ;; File menu
        .addr   disk_copy_overlay4_quit
        ;; Facilities menu
        .addr   cmd_quick_copy
        .addr   cmd_disk_copy

menu_offset_table:
        .byte   0, 5*2, 6*2, 8*2

LD9D5:  lda     event_modifiers
        bne     :+
        lda     event_key
        and     #CHAR_MASK
        cmp     #CHAR_ESCAPE
        beq     :+
        jmp     LDBFC
        ;; Keyboard-based menu selection
:       lda     #1
        sta     LD12F
        lda     event_key
        sta     menukey_params::which_key
        lda     event_modifiers
        sta     menukey_params::key_mods
        MGTK_RELAY_CALL2 MGTK::MenuKey, menukey_params
handle_menu_selection:
        ldx     menuselect_params::menu_id
        bne     :+
        rts
        ;; Compute offset into command table - menu offset + item offset
:       dex
        lda     menu_offset_table,x
        tax
        ldy     menuselect_params::menu_item
        dey
        tya
        asl     a
        sta     jump_addr
        txa
        clc
        adc     jump_addr
        tax
        copy16  menu_command_table,x, jump_addr
        jsr     do_jump
        MGTK_RELAY_CALL2 MGTK::HiliteMenu, hilitemenu_params
        jmp     LD986

do_jump:
        tsx
        stx     stack_stash
        jump_addr := *+1
        jmp     dummy1234

cmd_quick_copy:
        lda     quick_copy_flag
        bne     LDA42
        rts

LDA42:  copy    #0, checkitem_params::check
        MGTK_RELAY_CALL2 MGTK::CheckItem, checkitem_params
        copy    quick_copy_flag, checkitem_params::menu_item
        copy    #1, checkitem_params::check
        MGTK_RELAY_CALL2 MGTK::CheckItem, checkitem_params
        copy    #0, quick_copy_flag
        lda     winfo_dialog::window_id
        jsr     set_win_port
        param_call draw_title_text, str_quick_copy_padded
        rts

cmd_disk_copy:
        lda     quick_copy_flag
        beq     LDA7D
        rts

LDA7D:  copy    #0, checkitem_params::check
        MGTK_RELAY_CALL2 MGTK::CheckItem, checkitem_params
        copy    #2, checkitem_params::menu_item
        copy    #1, checkitem_params::check
        MGTK_RELAY_CALL2 MGTK::CheckItem, checkitem_params
        copy    #1, quick_copy_flag
        lda     winfo_dialog::window_id
        jsr     set_win_port
        param_call draw_title_text, str_disk_copy_padded
        rts

handle_button_down:
        MGTK_RELAY_CALL2 MGTK::FindWindow, event_xcoord
        lda     findwindow_which_area
        bne     :+
        rts                     ; desktop - ignore
:       cmp     #MGTK::Area::menubar
        bne     :+
        MGTK_RELAY_CALL2 MGTK::MenuSelect, menuselect_params
        jmp     handle_menu_selection
:       cmp     #MGTK::Area::content
        bne     :+
        jmp     handle_content_button_down
:       return  #$FF

handle_content_button_down:
        lda     LD133
        cmp     winfo_dialog::window_id
        bne     check_drive_select
        jmp     handle_dialog_button_down

check_drive_select:
        cmp     winfo_drive_select
        bne     :+
        jmp     handle_drive_select_button_down
:       rts

handle_dialog_button_down:
        lda     winfo_dialog::window_id
        sta     screentowindow_window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::ScreenToWindow, screentowindow_params
        MGTK_RELAY_CALL2 MGTK::MoveTo, screentowindow_windowx

check_ok_button:
        MGTK_RELAY_CALL2 MGTK::InRect, rect_ok_button
        cmp     #MGTK::inrect_inside
        beq     :+
        jmp     check_read_drive_button
:       MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        jsr     handle_ok_button_down
        rts

check_read_drive_button:
        MGTK_RELAY_CALL2 MGTK::InRect, rect_read_drive
        cmp     #MGTK::inrect_inside
        bne     :+
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_read_drive
        jsr     handle_read_drive_button_down
        rts

:       return  #$FF

handle_drive_select_button_down:
        lda     winfo_drive_select
        sta     screentowindow_window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::ScreenToWindow, screentowindow_params
        MGTK_RELAY_CALL2 MGTK::MoveTo, screentowindow_windowx
        lsr16   screentowindow_windowy ; / 8
        lsr16   screentowindow_windowy
        lsr16   screentowindow_windowy
        lda     screentowindow_windowy
        cmp     num_drives
        bcc     LDB98
        lda     current_drive_selection
        jsr     highlight_row
        lda     #$FF
        sta     current_drive_selection           ; $FF if no selection?
        jmp     LDBCA

LDB98:  cmp     current_drive_selection
        bne     LDBCD
        bit     LD368
        bpl     LDBC0
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        return  #$00

LDBC0:  lda     #$FF
        sta     LD368
        lda     #$64
        sta     LD367
LDBCA:  return  #$FF

LDBCD:  pha
        lda     current_drive_selection
        bmi     LDBD6
        jsr     highlight_row
LDBD6:  pla
        sta     current_drive_selection
        jsr     highlight_row
        jmp     LDBC0

.proc MGTK_RELAY2
        sty     call
        stax    params
        sta     RAMRDON
        sta     RAMWRTON
        jsr     MGTK::MLI
call:   .byte   0
params: .addr   0
        sta     RAMRDOFF
        sta     RAMWRTOFF
        rts
.endproc

LDBFC:  lda     event_key
        and     #CHAR_MASK
        cmp     #'D'
        beq     LDC09
        cmp     #'d'
        bne     LDC2D
LDC09:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_read_drive
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_read_drive
        return  #$01

LDC2D:  cmp     #CHAR_RETURN
        bne     LDC55
        lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        return  #$00

LDC55:  bit     LD44C
        bmi     check_down
        jmp     LDCA9

.proc check_down
        cmp     #CHAR_DOWN
        bne     check_up
        lda     winfo_drive_select
        jsr     set_win_port
        lda     current_drive_selection
        bmi     LDC6F
        jsr     highlight_row
LDC6F:  inc     current_drive_selection
        lda     current_drive_selection
        cmp     num_drives
        bcc     LDC7F
        lda     #$00
        sta     current_drive_selection
LDC7F:  jsr     highlight_row
        jmp     LDCA9
.endproc

.proc check_up
        cmp     #CHAR_UP
        bne     LDCA9
        lda     winfo_drive_select
        jsr     set_win_port
        lda     current_drive_selection
        bmi     LDC9C
        jsr     highlight_row
        dec     current_drive_selection
        bpl     LDCA3
LDC9C:  ldx     num_drives
        dex
        stx     current_drive_selection
LDCA3:  lda     current_drive_selection
        jsr     highlight_row
        ;; fall through
.endproc

LDCA9:  return  #$FF

;;; ============================================================

.proc handle_read_drive_button_down
        lda     #$00
        sta     state
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LDD14
        lda     winfo_dialog::window_id
        sta     screentowindow_window_id
        MGTK_RELAY_CALL2 MGTK::ScreenToWindow, screentowindow_params
        MGTK_RELAY_CALL2 MGTK::MoveTo, screentowindow_windowx
        MGTK_RELAY_CALL2 MGTK::InRect, rect_read_drive
        cmp     #MGTK::inrect_inside
        beq     LDCEE
        lda     state
        beq     LDCF6
        jmp     loop

LDCEE:  lda     state
        bne     LDCF6
        jmp     loop

LDCF6:  MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_read_drive
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LDD14:  lda     state
        beq     LDD1C
        return  #$FF

LDD1C:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_read_drive
        return  #$01

state:  .byte   0
.endproc

;;; ============================================================

.proc handle_ok_button_down
        lda     #$00
        sta     state
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LDDA0
        lda     winfo_dialog::window_id
        sta     screentowindow_window_id
        MGTK_RELAY_CALL2 MGTK::ScreenToWindow, screentowindow_params
        MGTK_RELAY_CALL2 MGTK::MoveTo, screentowindow_windowx
        MGTK_RELAY_CALL2 MGTK::InRect, rect_ok_button
        cmp     #MGTK::inrect_inside
        beq     LDD7A
        lda     state
        beq     LDD82
        jmp     loop

LDD7A:  lda     state
        bne     LDD82
        jmp     loop

LDD82:  MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LDDA0:  lda     state
        beq     LDDA8
        return  #$FF

LDDA8:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_ok_button
        return  #$00

state:  .byte   0
.endproc

;;; ============================================================

.proc set_cursor_watch
        MGTK_RELAY_CALL2 MGTK::HideCursor
        MGTK_RELAY_CALL2 MGTK::SetCursor, watch_cursor
        MGTK_RELAY_CALL2 MGTK::ShowCursor
        rts
.endproc

;;; ============================================================

.proc set_cursor_pointer
        MGTK_RELAY_CALL2 MGTK::HideCursor
        MGTK_RELAY_CALL2 MGTK::SetCursor, pointer_cursor
        MGTK_RELAY_CALL2 MGTK::ShowCursor
        rts
.endproc

;;; ============================================================

LDDFC:  sta     disk_copy_overlay4_block_params_unit_num
        lda     #$00
        sta     disk_copy_overlay4_block_params_block_num
        sta     disk_copy_overlay4_block_params_block_num+1
        copy16  #$1C00, disk_copy_overlay4_block_params_data_buffer
        jsr     disk_copy_overlay4_L12AF
        beq     LDE19
        return  #$FF

LDE19:  lda     $1C01
        cmp     #$E0
        beq     LDE23
        jmp     LDE4D

LDE23:  lda     $1C02
        cmp     #$70
        beq     LDE31
        cmp     #$60
        beq     LDE31
LDE2E:  return  #$FF

LDE31:  lda     num_drives
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     #<drive_name_table
        tay
        lda     #>drive_name_table
        adc     #0
        tax
        tya
        jsr     LDE9F
        lda     #$80
        sta     LD44E
        return  #$00

LDE4D:  cmp     #$A5
        bne     LDE2E
        lda     $1C02
        cmp     #ERR_IO_ERROR
        bne     LDE2E
        lda     disk_copy_overlay4_block_params_unit_num
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #'0'
        sta     str_dos33_s_d + kStrDOS33SlotOffset
        lda     disk_copy_overlay4_block_params_unit_num
        and     #$80
        asl     a
        rol     a
        adc     #'1'
        sta     str_dos33_s_d + kStrDOS33DriveOffset
        lda     num_drives
        asl     a
        asl     a
        asl     a
        asl     a
        tay
        ldx     #$00
LDE83:  lda     str_dos33_s_d,x
        sta     drive_name_table,y
        iny
        inx
        cpx     str_dos33_s_d
        bne     LDE83
        lda     str_dos33_s_d,x
        sta     drive_name_table,y
        lda     #$43
        sta     $0300
        return  #$00

        .byte   0
LDE9F:  stax    $06
        copy16  #$0002, disk_copy_overlay4_block_params_block_num
        jsr     disk_copy_overlay4_L12AF
        beq     LDEBE
        ldy     #$00
        lda     #$01
        sta     ($06),y
        iny
        lda     #$20
        sta     ($06),y
        rts

LDEBE:  ldy     #$00
        ldx     #$00
LDEC2:  lda     $1C06,x
        sta     ($06),y
        inx
        iny
        cpx     $1C06
        bne     LDEC2
        lda     $1C06,x
        sta     ($06),y
        lda     $1C06
        cmp     #$0F
        bcs     LDEE6
        ldy     #$00
        lda     ($06),y
        clc
        adc     #$01
        sta     ($06),y
        lda     ($06),y
        tay
LDEE6:  lda     #$3A
        sta     ($06),y
        rts

.proc number_to_string
        stax    number
        ldx     #7
        lda     #' '
:       sta     str_number,x
        dex
        bne     :-

        lda     #0
        sta     LDF72

        ldy     #0
        ldx     #0
LDF04:  lda     #0
        sta     LDF71
LDF09:  cmp16   number, tens_table,x

        bpl     LDF45
        lda     LDF71
        bne     LDF25
        bit     LDF72
        bmi     LDF25
        lda     #$20
        bne     LDF38
LDF25:  cmp     #$0A
        bcc     LDF2F
        clc
        adc     #$37
        jmp     LDF31

LDF2F:  adc     #'0'
LDF31:  pha
        lda     #$80
        sta     LDF72
        pla
LDF38:  sta     str_number+2,y
        iny
        inx
        inx
        cpx     #$08
        beq     LDF5E
        jmp     LDF04

LDF45:  inc     LDF71
        sub16   number, tens_table,x, number
        jmp     LDF09

LDF5E:  lda     number
        ora     #'0'
        sta     str_number+2,y
        rts

tens_table:
        .word   10000, 1000, 100, 10

number: .word   0
LDF71:  .byte   0
LDF72:  .byte   0
.endproc


;;; ============================================================

.proc remove_ram_disk
        ;; Find Slot 3 Drive 2 RAM disk
        ldx     DEVCNT
:       lda     DEVLST,x
        and     #%11110000      ; DSSSnnnn
        cmp     #$B0            ; Slot 3, Drive 2 = /RAM
        beq     remove
        dex
        bpl     :-
        rts

        ;; Remove it, shuffle everything else down.
remove: lda     DEVLST,x
        sta     saved_ram_unitnum

shift:  lda     DEVLST+1,x
        sta     DEVLST,x
        cpx     DEVCNT
        beq     :+
        inx
        jmp     shift

:       dec     DEVCNT
        rts
.endproc

;;; ============================================================

.proc restore_ram_disk
        inc     DEVCNT
        ldx     DEVCNT
        lda     saved_ram_unitnum
        sta     DEVLST,x
        rts
.endproc

saved_ram_unitnum:
        .byte   0

;;; ============================================================

.proc open_dialog
        MGTK_RELAY_CALL2 MGTK::OpenWindow, winfo_dialog
        lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_outer_frame
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_inner_frame

        MGTK_RELAY_CALL2 MGTK::InitPort, grafport
        MGTK_RELAY_CALL2 MGTK::SetPort, grafport
        rts
.endproc

.proc draw_dialog
        lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D211
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D219
        lda     quick_copy_flag
        bne     :+
        param_call draw_title_text, str_quick_copy_padded
        jmp     draw_buttons
:       param_call draw_title_text, str_disk_copy_padded

draw_buttons:
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_ok_button
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_read_drive
        jsr     draw_ok_label
        jsr     draw_read_drive_label
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_slot_drive_name
        param_call DrawString, str_slot_drive_name
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_select_source
        param_call DrawString, str_select_source
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_select_quit
        param_call DrawString, str_select_quit

        MGTK_RELAY_CALL2 MGTK::InitPort, grafport
        MGTK_RELAY_CALL2 MGTK::SetPort, grafport
        rts

draw_ok_label:
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_ok_label
        param_call DrawString, str_ok_label
        rts

draw_read_drive_label:
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_read_drive
        param_call DrawString, str_read_drive
        rts

.endproc

;;; ============================================================

.proc DrawString
        ptr := $0A

        stax    ptr
        ldy     #$00
        lda     (ptr),y
        sta     ptr+2
        inc16   ptr
        MGTK_RELAY_CALL2 MGTK::DrawText, ptr
        rts
.endproc

;;; ============================================================

.proc draw_title_text
        text_params := $06
        text_addr := text_params + 0
        text_length := text_params + 2
        text_width := text_params + 3

        stax    text_addr
        ldy     #$00
        lda     (text_addr),y
        sta     text_length
        inc16   text_addr
        MGTK_RELAY_CALL2 MGTK::TextWidth, text_params
        lsr16   text_width
        lda     #>500
        sta     width_hi
        lda     #<500
        lsr     width_hi
        ror     a
        sec
        sbc     text_width
        sta     point_title
        lda     width_hi
        sbc     text_width+1
        sta     point_title+1
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_title
        MGTK_RELAY_CALL2 MGTK::DrawText, text_params
        rts

width_hi:
        .byte   0
.endproc

;;; ============================================================

.proc adjust_case
        ptr := $A

        stx     ptr+1
        sta     ptr
        ldy     #0
        lda     (ptr),y
        tay
        bne     next
        rts

next:   dey
        beq     done
        bpl     :+
done:   rts

:       lda     (ptr),y
        and     #CHAR_MASK      ; convert to ASCII
        cmp     #'/'
        beq     skip
        cmp     #'.'
        bne     check_alpha
skip:   dey
        jmp     next

check_alpha:
        iny
        lda     (ptr),y
        and     #CHAR_MASK
        cmp     #'A'
        bcc     :+
        cmp     #'Z'+1
        bcs     :+
        clc
        adc     #('a' - 'A')    ; convert to lower case
        sta     (ptr),y
:       dey
        jmp     next
.endproc

;;; ============================================================

.proc set_win_port
        sta     getwinport_params::window_id
        MGTK_RELAY_CALL2 MGTK::GetWinPort, getwinport_params
        MGTK_RELAY_CALL2 MGTK::SetPort, grafport_win
        rts
.endproc

;;; ============================================================

.proc highlight_row
        asl     a               ; * 8
        asl     a
        asl     a
        sta     rect_D35B::y1
        clc
        adc     #7
        sta     rect_D35B::y2
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D35B
        rts
.endproc

;;; ============================================================

.proc enumerate_devices
        lda     #$00
        sta     LD44E
        sta     disk_copy_overlay4_on_line_params2_unit_num
        jsr     disk_copy_overlay4_L1291
        beq     LE17A

        brk

LE17A:  lda     #$00
        sta     device_index
        sta     num_drives
LE182:  lda     #$13
        sta     $07
        lda     #$00
        sta     $06
        sta     LE264
        lda     device_index
        asl     a
        rol     LE264
        asl     a
        rol     LE264
        asl     a
        rol     LE264
        asl     a
        rol     LE264
        clc
        adc     $06
        sta     $06
        lda     LE264
        adc     $07
        sta     $07

        ;; Check first byte of record
        ldy     #0
        lda     ($06),y
        and     #$0F            ; name_len
        bne     LE20D

        lda     ($06),y         ; 0?
        beq     LE1CC           ; done!

        iny                     ; name_len=0 signifies an error
        lda     ($06),y         ; error code in second byte
        cmp     #ERR_DEVICE_NOT_CONNECTED
        bne     LE1CD
        dey
        lda     ($06),y
        jsr     find_devlst_index
        lda     #ERR_DEVICE_NOT_CONNECTED
        bcc     LE1CD           ; ???
        jmp     next_device

LE1CC:  rts

LE1CD:  pha
        ldy     #$00
        lda     ($06),y
        jsr     find_unit_num
        ldx     num_drives
        sta     drive_unitnum_table,x
        pla
        cmp     #ERR_NOT_PRODOS_VOLUME
        bne     LE1EA
        lda     drive_unitnum_table,x
        and     #$F0
        jsr     LDDFC
        beq     LE207
LE1EA:  lda     num_drives
        asl     a
        asl     a
        asl     a
        asl     a
        tay
        ldx     #$00
LE1F4:  lda     str_unknown,x
        sta     drive_name_table,y
        iny
        inx
        cpx     str_unknown
        bne     LE1F4
        lda     str_unknown,x
        sta     drive_name_table,y
LE207:  inc     num_drives
        jmp     next_device

        ;; Valid ProDOS volume
LE20D:  ldx     num_drives
        ldy     #$00
        lda     ($06),y
        and     #$70            ; slot 3?
        cmp     #$30
        bne     LE21D
        jmp     next_device     ; if so, skip

LE21D:  ldy     #$00
        lda     ($06),y
        jsr     find_unit_num
        ldx     num_drives
        sta     drive_unitnum_table,x
        lda     num_drives
        asl     a
        asl     a
        asl     a
        asl     a
        tax
        ldy     #$00
        lda     ($06),y
        and     #$0F
        sta     drive_name_table,x
        sta     LE264
LE23E:  inx
        iny
        cpy     LE264
        beq     LE24D
        lda     ($06),y
        sta     drive_name_table,x
        jmp     LE23E

LE24D:  lda     ($06),y
        sta     drive_name_table,x
        inc     num_drives


next_device:
        inc     device_index
        lda     device_index
        cmp     #$08            ; max number of devices shown???
        beq     LE262
        jmp     LE182

LE262:  rts

device_index:
        .byte   0
LE264:  .byte   0

;;; --------------------------------------------------
;;; Inputs: A=driver/slot (DSSSxxxx)
;;; Outputs: C=0, X=DEVLST index is found and low bits of unit_num != 0
;;;          C=1 otherwise

.proc find_devlst_index
        and     #$F0
        sta     LE28C
        ldx     DEVCNT
loop:   lda     DEVLST,x
        and     #$F0
        cmp     LE28C
        beq     match
        dex
        bpl     loop
err:    sec
        rts

        ;; Drive/slot matches. Check low nibble.
match:  lda     DEVLST,x
        and     #$0F
        bne     err
        clc
        rts
.endproc

;;; --------------------------------------------------
;;; Inputs: A=driver/slot (DSSSxxxx)
;;; Outputs: unit_num

.proc find_unit_num
        jsr     find_devlst_index
        lda     DEVLST,x
        rts
.endproc

LE28C:  .byte   0

.endproc

;;; ============================================================

.proc draw_device_list_entries
        lda     winfo_drive_select
        jsr     set_win_port

        lda     #0
        sta     index

loop:   lda     index
        jsr     LE39A

        lda     index
        jsr     draw_device_list_entry
        inc     index

        lda     index
        cmp     num_drives
        bne     loop

        rts

index:  .byte   0
.endproc

;;; ============================================================

LE2B1:  lda     winfo_drive_select
        jsr     set_win_port
        lda     current_drive_selection
        asl     a
        tax
        lda     block_count_table,x
        sta     LE318
        lda     block_count_table+1,x
        sta     LE318+1
        lda     num_drives
        sta     LD376
        lda     #$00
        sta     num_drives
        sta     LE317
LE2D6:  lda     LE317
        asl     a
        tax
        lda     block_count_table,x
        cmp     LE318
        bne     LE303
        lda     block_count_table+1,x
        cmp     LE318+1
        bne     LE303
        lda     LE317
        ldx     num_drives
        sta     LD3FF,x
        lda     num_drives
        jsr     LE39A
        lda     LE317
        jsr     draw_device_list_entry
        inc     num_drives
LE303:  inc     LE317
        lda     LE317
        cmp     LD376
        beq     LE311
        jmp     LE2D6

LE311:  lda     #$FF
        sta     current_drive_selection
        rts

LE317:  .byte   0
LE318:  .addr   0
        .byte   0

;;; ============================================================

.proc draw_device_list_entry
        sta     device_index

        ;; Slot
        lda     #8
        sta     point_D36D::xcoord
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_D36D
        ldx     device_index
        lda     drive_unitnum_table,x
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #'0'
        sta     str_s + 1
        param_call DrawString, str_s

        ;; Drive
        lda     #40
        sta     point_D36D::xcoord
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_D36D
        ldx     device_index
        lda     drive_unitnum_table,x
        and     #$80
        asl     a
        rol     a
        clc
        adc     #'1'
        sta     str_d + 1
        param_call DrawString, str_d

        ;; Name
        lda     #65
        sta     point_D36D::xcoord
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_D36D
        lda     device_index
        asl     a
        asl     a
        asl     a
        asl     a
        clc
        adc     #<drive_name_table
        sta     $06
        lda     #>drive_name_table
        adc     #$00
        sta     $07
        lda     $06
        ldx     $07
        jsr     adjust_case
        lda     $06
        ldx     $07
        jsr     DrawString
        rts

device_index:
        .byte   0
.endproc

;;; ============================================================

.proc LE39A
        asl     a
        asl     a
        asl     a
        adc     #8
        sta     point_D36D::ycoord
        rts
.endproc

;;; ============================================================
;;; Populate block_count_table across all devices

.proc get_all_block_counts
        lda     #0
        sta     index

:       jsr     get_block_count
        inc     index
        lda     index
        cmp     num_drives
        bne     :-
        rts

index:  .byte   0
.endproc

;;; ============================================================
;;; Inputs: A = device index
;;; Outputs: block_count_table (word) set to block count

.proc get_block_count

        ;; TODO: Figure out why we can't just always use the device driver!

        pha
        tax                     ; X is device index
        lda     drive_unitnum_table,x
        and     #$0F            ; is Disk II ?
        beq     disk_ii

        lda     drive_unitnum_table,x
        jsr     disk_copy_overlay4_unit_number_to_driver_address
        jmp     other_device

        ;; Disk II - always 280 blocks
disk_ii:
        pla
        asl     a
        tax
        lda     #<280
        sta     block_count_table,x
        lda     #>280
        sta     block_count_table+1,x
        rts

        ;; Other devices...
other_device:
        bne     use_driver      ; if not firmware, can't do these tests

        lda     #$00
        sta     $06
        ldy     #$07            ; $Cn07 = $00 if SmartPort
        lda     ($06),y
        bne     :+
        jmp     smartport

        ;; Not smartport
:       lda     #$00
        sta     LE448
        ldy     #$FC            ; $CnFC/$CnFD = Total number of blocks on device
        lda     ($06),y
        sta     LE449
        beq     LE3F6
        lda     #$80
        sta     LE448
LE3F6:  ldy     #$FD
        lda     ($06),y
        tax
        bne     LE402
        bit     LE448
        bpl     LE415
LE402:  stx     LE448

        pla
        asl     a
        tax
        lda     LE448
        sta     block_count_table,x
        lda     LE449
        sta     block_count_table+1,x
        rts

LE415:  ldy     #$FF            ; offset to low byte of driver address
        lda     ($06),y
        sta     $06

use_driver:
        pla
        pha
        tax
        lda     drive_unitnum_table,x
        ldxy    $06

        jsr     disk_copy_overlay4_get_device_blocks_using_driver

        stx     LE448           ; blocks available low
        pla
        asl     a
        tax
        lda     LE448
        sta     block_count_table,x
        tya                     ; blocks available high
        sta     block_count_table+1,x
        rts

LE448:  .byte   0
LE449:  .byte   0

        ;; Compute SmartPort entry point
smartport:
        ldy     #$FF            ; $CnFF...
        lda     ($06),y
        clc
        adc     #$03            ; + 3 is low byte of firmware entry point
        sta     $06
        pla
        pha
        tax
        lda     drive_unitnum_table,x
        and     #$F0
        jsr     disk_copy_overlay4_unit_num_to_sp_unit_number
        sta     status_unit_num

        jsr     indirect_jump
        .byte   $00             ; $00 = STATUS
        .word   status_params

        pla
        asl     a
        tax
        lda     LE482
        sta     block_count_table,x
        lda     LE483
        sta     block_count_table+1,x
        rts

indirect_jump:
        jmp     ($06)

.endproc

;;; ============================================================

        ;; TODO: Identify data
        .byte   0
        .byte   0

.params status_params
param_count:
        .byte   3
unit_num:
        .byte   1
        .addr   status_buffer
        .byte   0
.endparams
status_unit_num := status_params::unit_num


status_buffer:
        .byte   0
LE482:  .byte   0
LE483:  .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0
        .byte   0

LE491:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_writing
        param_call DrawString, str_writing
        rts

LE4A8:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_reading
        param_call DrawString, str_reading
        rts

LE4BF:  lda     winfo_dialog::window_id
        jsr     set_win_port
        lda     source_drive_index
        asl     a
        tay
        lda     block_count_table+1,y
        tax
        lda     block_count_table,y
        jsr     number_to_string
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_source
        param_call DrawString, str_blocks_to_transfer
        param_call DrawString, str_number
        rts

LE4EC:  jsr     LE522
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_blocks_read
        param_call DrawString, str_blocks_read
        param_call DrawString, str_number
        rts

LE507:  jsr     LE522
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_blocks_written
        param_call DrawString, str_blocks_written
        param_call DrawString, str_number
        rts

LE522:  lda     winfo_dialog::window_id
        jsr     set_win_port
        lda     LD421+1
        sta     LE558
        lda     LD421
        asl     a
        rol     LE558
        asl     a
        rol     LE558
        asl     a
        rol     LE558
        ldx     LD423
        clc
        adc     LE550,x
        tay
        lda     LE558
        adc     #$00
        tax
        tya
        jsr     number_to_string
        rts

LE550:  .byte   7,6,5,4,3,2,1,0

LE558:  .byte   0
LE559:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_source2
        param_call DrawString, str_source
        ldx     source_drive_index
        lda     drive_unitnum_table,x
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #'0'
        sta     str_s + 1
        ldx     source_drive_index
        lda     drive_unitnum_table,x
        and     #$80
        clc
        rol     a
        rol     a
        clc
        adc     #'1'
        sta     str_d + 1
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_slot_drive
        param_call DrawString, str_slot
        param_call DrawString, str_s
        param_call DrawString, str_drive
        param_call DrawString, str_d
        bit     LD44D
        bpl     LE5C6
        bvc     LE5C5
        lda     LD44D
        and     #$0F
        beq     LE5C6
LE5C5:  rts

LE5C6:  param_call DrawString, str_2_spaces
        ldx     $1300
LE5D0:  lda     $1300,x
        sta     LD43A,x
        dex
        bpl     LE5D0
        param_call DrawString, LD43A
        rts

LE5E1:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_destination
        param_call DrawString, str_destination
        ldx     dest_drive_index
        lda     drive_unitnum_table,x
        and     #$70
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #'0'
        sta     str_s + 1
        ldx     dest_drive_index
        lda     drive_unitnum_table,x
        and     #$80
        asl     a
        rol     a
        clc
        adc     #'1'
        sta     str_d + 1
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_slot_drive2
        param_call DrawString, str_slot
        param_call DrawString, str_s
        param_call DrawString, str_drive
        param_call DrawString, str_d
        rts

LE63F:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_disk_copy
        bit     LD44D
        bmi     LE65B
        param_call DrawString, str_prodos_disk_copy
        rts

LE65B:  bvs     LE665
        param_call DrawString, str_dos33_disk_copy
        rts

LE665:  lda     LD44D
        and     #$0F
        bne     LE673
        param_call DrawString, str_pascal_disk_copy
LE673:  rts

LE674:  lda     LD44D
        cmp     #$C0
        beq     LE693
        lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_D483
LE693:  rts

LE694:  lda     winfo_dialog::window_id
        jsr     set_win_port
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_escape_stop_copy
        param_call DrawString, str_escape_stop_copy
        rts

LE6AB:  lda     winfo_dialog::window_id
        jsr     set_win_port
        copy16  #$800A, LE6FB
LE6BB:  dec     LE6FB
        beq     LE6F1
        lda     LE6FC
        eor     #$80
        sta     LE6FC
        beq     LE6D5
        MGTK_RELAY_CALL2 MGTK::SetTextBG, bg_white
        beq     LE6DE
LE6D5:  MGTK_RELAY_CALL2 MGTK::SetTextBG, bg_black
LE6DE:  MGTK_RELAY_CALL2 MGTK::MoveTo, point_escape_stop_copy
        param_call DrawString, str_escape_stop_copy
        jmp     LE6BB

LE6F1:  MGTK_RELAY_CALL2 MGTK::SetTextBG, bg_white
        rts

LE6FB:  .byte   0
LE6FC:  .byte   0
LE6FD:  stx     LE765

        cmp     #ERR_WRITE_PROTECTED
        bne     LE71A
        jsr     disk_copy_overlay4_bell
        lda     #5              ; Destination protected
        jsr     show_alert_dialog
        bne     LE714
        jsr     LE491
        return  #$01

LE714:  jsr     disk_copy_overlay4_L10FB
        return  #$80

LE71A:  jsr     disk_copy_overlay4_bell
        lda     winfo_dialog::window_id
        jsr     set_win_port
        lda     disk_copy_overlay4_block_params_block_num
        ldx     disk_copy_overlay4_block_params_block_num+1
        jsr     number_to_string
        lda     LE765
        bne     LE74B
        MGTK_RELAY_CALL2 MGTK::MoveTo, point_error_reading
        param_call DrawString, str_error_reading
        param_call DrawString, str_number
        return  #$00

LE74B:  MGTK_RELAY_CALL2 MGTK::MoveTo, point_error_writing
        param_call DrawString, str_error_writing
        param_call DrawString, str_number
        return  #$00

LE765:  .byte   0
LE766:  sta     $06
        sta     $08
        stx     $07
        stx     $09
        inc     $09
        copy16  #$1C00, disk_copy_overlay4_block_params_data_buffer
LE77A:  jsr     disk_copy_overlay4_L12AF
        beq     LE789
        ldx     #$00
        jsr     LE6FD
        beq     LE789
        bpl     LE77A
        rts

LE789:  sta     RAMRDOFF
        sta     RAMWRTON
        ldy     #$FF
        iny
LE792:  lda     $1C00,y
        sta     ($06),y
        lda     $1D00,y
        sta     ($08),y
        iny
        bne     LE792
        sta     RAMRDOFF
        sta     RAMWRTOFF
        lda     #$00
        rts

LE7A8:  sta     $06
        sta     $08
        stx     $07
        stx     $09
        inc     $09
        copy16  #$1C00, disk_copy_overlay4_block_params_data_buffer
        .byte   $8D
        .byte   $03
        cpy     #$8D
        .byte   $04
        cpy     #$A0
        .byte   $FF
        iny
LE7C5:  lda     ($06),y
        sta     $1C00,y
        lda     ($08),y
        sta     $1D00,y
        iny
        bne     LE7C5
        sta     RAMRDOFF
        sta     RAMWRTOFF
LE7D8:  jsr     disk_copy_overlay4_L12A5
        beq     LE7E6
        ldx     #$80
        jsr     LE6FD
        beq     LE7E6
        bpl     LE7D8
LE7E6:  rts

;;; ============================================================

.proc alert_dialog

alert_bitmap:
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0000000),PX(%1111111),PX(%1111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111100),PX(%1111100),PX(%0000001),PX(%1110000),PX(%0000111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111100),PX(%1111100),PX(%0000011),PX(%1100000),PX(%0000011),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0000111),PX(%1100111),PX(%1111001),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0001111),PX(%1100111),PX(%1111001),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111111),PX(%1111001),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111111),PX(%1110011),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111111),PX(%1100111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111111),PX(%1001111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111111),PX(%0011111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111110),PX(%0111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111100),PX(%1111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1111100),PX(%0011111),PX(%1111100),PX(%1111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111110),PX(%0000000),PX(%0111111),PX(%1111111),PX(%1111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1100000),PX(%1111111),PX(%1111100),PX(%1111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1100001),PX(%1111111),PX(%1111111),PX(%1111111),PX(%0000000),PX(%0000000)
        .byte   PX(%0111000),PX(%0000011),PX(%1111111),PX(%1111111),PX(%1111110),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1100000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0111111),PX(%1100000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)

.params alert_bitmap_mapinfo
viewloc:        DEFINE_POINT 20, 8
mapbits:        .addr   alert_bitmap
mapwidth:       .byte   7
reserved:       .byte   0
maprect:        DEFINE_RECT 0, 0, 36, 23
.endparams

rect_E89F:      DEFINE_RECT 65, 45, 485, 100
rect_E8A7:      DEFINE_RECT_INSET 4, 2, 420, 55
rect_E8AF:      DEFINE_RECT_INSET 5, 3, 420, 55

.params portbits1
viewloc:        DEFINE_POINT 65, 45, viewloc
mapbits:        .addr   MGTK::screen_mapbits
mapwidth:       .byte   MGTK::screen_mapwidth
reserved:       .byte   0
maprect:        DEFINE_RECT 0, 0, 420, 55
.endparams

.params portbits2
viewloc:        DEFINE_POINT 0, 0
mapbits:        .addr   MGTK::screen_mapbits
mapwidth:       .byte   MGTK::screen_mapwidth
reserved:       .byte   0
maprect:        DEFINE_RECT 0, 0, 559, 191
.endparams

        DEFINE_BUTTON ok,     "OK            \x0D", 300, 37
        DEFINE_BUTTON cancel, "Cancel     Esc",      20, 37
try_again_button_label:
        PASCAL_STRING "Try Again     A" ; button label
try_again_button_rect = ok_button_rect
try_again_button_pos  = ok_button_pos

        DEFINE_BUTTON yes, "Yes", 250, 37, 50, kButtonHeight
        DEFINE_BUTTON no,  "No",  350, 37, 50, kButtonHeight

LE93D:  DEFINE_POINT 100, 24

message_flags:
        .byte   0
LE942:  .addr   0

str_insert_source:
        PASCAL_STRING "Insert source disk and click OK."
str_insert_dest:
        PASCAL_STRING "Insert destination disk and click OK."

str_confirm_erase0:
        PASCAL_STRING "Do you want to erase "
str_confirm_erase0_buf:  .res    18, 0
kLenConfirmErase0 = 23 ; ??? Should be 21?

str_dest_format_fail:
        PASCAL_STRING "The destination disk cannot be formated !"
str_format_error:
        PASCAL_STRING "Error during formating."
str_dest_protected:
        PASCAL_STRING "The destination volume is write protected !"

str_confirm_erase1:
        PASCAL_STRING "Do you want to erase "
str_confirm_erase1_buf:  .res    18, 0
kLenConfirmErase1 = 21

str_confirm_erase2:
        PASCAL_STRING "Do you want to  erase  the disk in slot # drive # ?"
        kStrConfirmErase2SlotOffset = 41
        kStrConfirmErase2DriveOffset = 49

str_confirm_erase3:
        PASCAL_STRING "Do you want to erase the disk in slot # drive # ?"
        kStrConfirmErase3SlotOffset = 39
        kStrConfirmErase3DriveOffset = 47

str_copy_success:
        PASCAL_STRING "The copy was successful."
str_copy_fail:
        PASCAL_STRING "The copy was not completed."
str_insert_source_or_cancel:
        PASCAL_STRING "Insert source disk or press Escape to cancel."
str_insert_dest_or_cancel:
        PASCAL_STRING "Insert destination disk or press Escape to cancel."

char_space:
        .byte   ' '
char_question_mark:
        .byte   '?'

message_index_table:
        .byte   0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12

message_table:
        .addr   str_insert_source
        .addr   str_insert_dest
        .addr   str_confirm_erase0
        .addr   str_dest_format_fail
        .addr   str_format_error
        .addr   str_dest_protected
        .addr   str_confirm_erase1
        .addr   str_confirm_erase2
        .addr   str_confirm_erase3
        .addr   str_copy_success
        .addr   str_copy_fail
        .addr   str_insert_source_or_cancel
        .addr   str_insert_dest_or_cancel

        ;; $C0 (%11xxxxxx) = Cancel + Ok
        ;; $81 (%10xxxxx1) = Cancel + Yes + No
        ;; $80 (%10xx0000) = Cancel + Try Again
        ;; $00 (%0xxxxxxx) = Ok

.enum MessageFlags
        OkCancel = $C0
        YesNoCancel = $81
        TryAgainCancel = $80
        Ok = $00
.endenum

message_flags_table:
        .byte   MessageFlags::OkCancel
        .byte   MessageFlags::OkCancel
        .byte   MessageFlags::YesNoCancel
        .byte   MessageFlags::Ok
        .byte   MessageFlags::TryAgainCancel
        .byte   MessageFlags::TryAgainCancel
        .byte   MessageFlags::YesNoCancel
        .byte   MessageFlags::YesNoCancel
        .byte   MessageFlags::YesNoCancel
        .byte   MessageFlags::Ok
        .byte   MessageFlags::Ok
        .byte   MessageFlags::Ok
        .byte   MessageFlags::Ok

LEB81:  .addr   0
LEB83:  .byte   0

show_alert_dialog:
        stax    LEB81
        sty     LEB83
        MGTK_RELAY_CALL2 MGTK::InitPort, grafport
        MGTK_RELAY_CALL2 MGTK::SetPort, grafport
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_E89F
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_E89F
        MGTK_RELAY_CALL2 MGTK::SetPortBits, portbits1
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_E8A7
        MGTK_RELAY_CALL2 MGTK::FrameRect, rect_E8AF
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::HideCursor
        MGTK_RELAY_CALL2 MGTK::PaintBits, alert_bitmap_mapinfo
        MGTK_RELAY_CALL2 MGTK::ShowCursor
        lda     #$00
        sta     LD41E
        lda     LEB81
        jsr     LF1CC
        ldy     LEB83
        ldx     LEB81+1
        lda     LEB81
        bne     LEC1F
        cpx     #$00
        beq     LEC5E
        jsr     LF185
        beq     LEC5E
        lda     #$0B
        bne     LEC5E
LEC1F:  cmp     #$01
        bne     LEC34
        cpx     #$00
        beq     LEC5E
        jsr     LF185
        beq     LEC30
        lda     #$0C
        bne     LEC5E
LEC30:  lda     #$01
        bne     LEC5E
LEC34:  cmp     #$02
        bne     LEC3F
        jsr     append_to_confirm_erase0
        lda     #$02
        bne     LEC5E
LEC3F:  cmp     #$06
        bne     :+
        jsr     append_to_confirm_erase1
        lda     #$06
        bne     LEC5E
:       cmp     #$07
        bne     LEC55
        jsr     set_confirm_erase2_slot_drive
        lda     #$07
        bne     LEC5E
LEC55:  cmp     #$08
        bne     LEC5E
        jsr     set_confirm_erase3_slot_drive
        lda     #$08
LEC5E:  ldy     #$00
LEC60:  cmp     message_index_table,y
        beq     LEC6C
        iny
        cpy     #$1E
        bne     LEC60
        ldy     #$00
LEC6C:  tya
        asl     a
        tay
        lda     message_table,y
        sta     LE942
        lda     message_table+1,y
        sta     LE942+1
        tya
        lsr     a
        tay
        lda     message_flags_table,y
        sta     message_flags
        bit     LD41E
        bpl     LEC8C
        jmp     LED23

LEC8C:  jsr     set_pen_xor
        bit     message_flags
        bpl     draw_ok_btn
        MGTK_RELAY_CALL2 MGTK::FrameRect, cancel_button_rect
        MGTK_RELAY_CALL2 MGTK::MoveTo, cancel_button_pos
        param_call DrawString, cancel_button_label
        bit     message_flags
        bvs     draw_ok_btn
        lda     message_flags
        and     #$0F
        beq     draw_try_again_btn

        MGTK_RELAY_CALL2 MGTK::FrameRect, yes_button_rect
        MGTK_RELAY_CALL2 MGTK::MoveTo, yes_button_pos
        param_call DrawString, yes_button_label

        MGTK_RELAY_CALL2 MGTK::FrameRect, no_button_rect
        MGTK_RELAY_CALL2 MGTK::MoveTo, no_button_pos
        param_call DrawString, no_button_label
        jmp     LED23

draw_try_again_btn:
        MGTK_RELAY_CALL2 MGTK::FrameRect, try_again_button_rect
        MGTK_RELAY_CALL2 MGTK::MoveTo, try_again_button_pos
        param_call DrawString, try_again_button_label
        jmp     LED23

draw_ok_btn:
        MGTK_RELAY_CALL2 MGTK::FrameRect, ok_button_rect
        MGTK_RELAY_CALL2 MGTK::MoveTo, ok_button_pos
        param_call DrawString, ok_button_label

LED23:  MGTK_RELAY_CALL2 MGTK::MoveTo, LE93D
        param_call_indirect DrawString, LE942
        ;; fall through

;;; ============================================================

input_loop:
        bit     LD41E
        bpl     LED45
        jsr     LF192
        bne     LED42
        jmp     LEDF2

LED42:  jmp     LED79

LED45:  MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_down
        bne     LED58
        jmp     handle_button_down

LED58:  cmp     #MGTK::EventKind::key_down
        bne     input_loop
        lda     event_key
        and     #CHAR_MASK
        bit     message_flags
        bmi     :+
        jmp     LEDE2

:       cmp     #CHAR_ESCAPE
        bne     :+
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, cancel_button_rect
LED79:  lda     #1
        jmp     clear_and_return_value

:       bit     message_flags
        bvs     LEDE2
        pha
        lda     message_flags
        and     #$0F
        beq     LEDC1
        pla
        cmp     #'N'
        beq     do_no
        cmp     #'n'
        beq     do_no
        cmp     #'Y'
        beq     do_yes
        cmp     #'y'
        beq     do_yes
        jmp     input_loop

do_no:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, no_button_rect
        lda     #3
        jmp     clear_and_return_value

do_yes: jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, yes_button_rect
        lda     #2
        jmp     clear_and_return_value

LEDC1:  pla
        cmp     #'a'
        bne     LEDD7
LEDC6:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, try_again_button_rect
        lda     #0
        jmp     clear_and_return_value

LEDD7:  cmp     #'A'
        beq     LEDC6
        cmp     #CHAR_RETURN
        beq     LEDC6
        jmp     input_loop

LEDE2:  cmp     #CHAR_RETURN
        bne     LEDF7
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, ok_button_rect
LEDF2:  lda     #0
        jmp     clear_and_return_value

LEDF7:  jmp     input_loop

handle_button_down:
        jsr     map_event_coords
        MGTK_RELAY_CALL2 MGTK::MoveTo, event_coords
        bit     message_flags
        bpl     LEE57
        MGTK_RELAY_CALL2 MGTK::InRect, cancel_button_rect
        cmp     #MGTK::inrect_inside
        bne     LEE1B
        jmp     handle_cancel_button_down

LEE1B:  bit     message_flags
        bvs     LEE57
        lda     message_flags
        and     #$0F
        beq     LEE47
        MGTK_RELAY_CALL2 MGTK::InRect, no_button_rect
        cmp     #MGTK::inrect_inside
        bne     LEE37
        jmp     handle_no_button_down

LEE37:  MGTK_RELAY_CALL2 MGTK::InRect, yes_button_rect
        cmp     #MGTK::inrect_inside
        bne     LEE67
        jmp     handle_yes_button_down

LEE47:  MGTK_RELAY_CALL2 MGTK::InRect, ok_button_rect
        cmp     #MGTK::inrect_inside
        bne     LEE67
        jmp     handle_ok_try_again_button_down1

LEE57:  MGTK_RELAY_CALL2 MGTK::InRect, try_again_button_rect
        cmp     #MGTK::inrect_inside
        bne     LEE67
        jmp     handle_ok_try_again_button_down2

LEE67:  jmp     input_loop

;;; ============================================================

clear_and_return_value:
        pha
        MGTK_RELAY_CALL2 MGTK::SetPortBits, portbits2
        MGTK_RELAY_CALL2 MGTK::SetPenMode, pencopy
        MGTK_RELAY_CALL2 MGTK::PaintRect, rect_E89F
        pla
        rts

;;; ============================================================

.proc handle_ok_try_again_button_down1
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, ok_button_rect
        lda     #$00
        sta     state
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LEEEA
        jsr     map_event_coords
        MGTK_RELAY_CALL2 MGTK::MoveTo, event_coords
        MGTK_RELAY_CALL2 MGTK::InRect, ok_button_rect
        cmp     #MGTK::inrect_inside
        beq     LEECA
        lda     state
        beq     LEED2
        jmp     loop

LEECA:  lda     state
        bne     LEED2
        jmp     loop

LEED2:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, ok_button_rect
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LEEEA:  lda     state
        beq     LEEF2
        jmp     input_loop

LEEF2:  lda     #0
        jmp     clear_and_return_value

state:
        .byte   0
.endproc

;;; ============================================================

.proc handle_cancel_button_down
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, cancel_button_rect
        lda     #$00
        sta     state
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LEF5A
        jsr     map_event_coords
        MGTK_RELAY_CALL2 MGTK::MoveTo, event_coords
        MGTK_RELAY_CALL2 MGTK::InRect, cancel_button_rect
        cmp     #MGTK::inrect_inside
        beq     LEF3A
        lda     state
        beq     LEF42
        jmp     loop

LEF3A:  lda     state
        bne     LEF42
        jmp     loop

LEF42:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, cancel_button_rect
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LEF5A:  lda     state
        beq     LEF62
        jmp     input_loop

LEF62:  lda     #1
        jmp     clear_and_return_value

state:
        .byte   0
.endproc

;;; ============================================================

.proc handle_ok_try_again_button_down2
        lda     #$00
        sta     state
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, try_again_button_rect
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LEFCA
        jsr     map_event_coords
        MGTK_RELAY_CALL2 MGTK::MoveTo, event_coords
        MGTK_RELAY_CALL2 MGTK::InRect, try_again_button_rect
        cmp     #MGTK::inrect_inside
        beq     LEFAA
        lda     state
        beq     LEFB2
        jmp     loop

LEFAA:  lda     state
        bne     LEFB2
        jmp     loop

LEFB2:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, try_again_button_rect
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LEFCA:  lda     state
        beq     LEFD2
        jmp     input_loop

LEFD2:  lda     #0
        jmp     clear_and_return_value

state:
        .byte   0
.endproc

;;; ============================================================

.proc handle_no_button_down
        lda     #$00
        sta     state
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, no_button_rect
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LF03A
        jsr     map_event_coords
        MGTK_RELAY_CALL2 MGTK::MoveTo, event_coords
        MGTK_RELAY_CALL2 MGTK::InRect, no_button_rect
        cmp     #MGTK::inrect_inside
        beq     LF01A
        lda     state
        beq     LF022
        jmp     loop

LF01A:  lda     state
        bne     LF022
        jmp     loop

LF022:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, no_button_rect
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LF03A:  lda     state
        beq     LF042
        jmp     input_loop

LF042:  lda     #3
        jmp     clear_and_return_value

state:
        .byte   0
.endproc

;;; ============================================================

.proc handle_yes_button_down
        lda     #$00
        sta     state
        jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, yes_button_rect
loop:   MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::button_up
        beq     LF0AA
        jsr     map_event_coords
        MGTK_RELAY_CALL2 MGTK::MoveTo, event_coords
        MGTK_RELAY_CALL2 MGTK::InRect, yes_button_rect
        cmp     #MGTK::inrect_inside
        beq     LF08A
        lda     state
        beq     LF092
        jmp     loop

LF08A:  lda     state
        bne     LF092
        jmp     loop

LF092:  jsr     set_pen_xor
        MGTK_RELAY_CALL2 MGTK::PaintRect, yes_button_rect
        lda     state
        clc
        adc     #$80
        sta     state
        jmp     loop

LF0AA:  lda     state
        beq     LF0B2
        jmp     input_loop

LF0B2:  lda     #2
        jmp     clear_and_return_value

state:
        .byte   0
.endproc

;;; ============================================================

.proc map_event_coords
        sub16   event_xcoord, portbits1::viewloc::xcoord, event_xcoord
        sub16   event_ycoord, portbits1::viewloc::ycoord, event_ycoord
        rts
.endproc

;;; ============================================================

.proc set_pen_xor
        MGTK_RELAY_CALL2 MGTK::SetPenMode, penXOR
        rts
.endproc

;;; ============================================================

.proc append_to_confirm_erase0
        ptr := $06
        stxy    ptr
        ldy     #$00
        lda     (ptr),y
        pha
        tay
:       lda     (ptr),y
        sta     str_confirm_erase0_buf-1,y
        dey
        bne     :-
        pla
        clc
        adc     #kLenConfirmErase0
        sta     str_confirm_erase0
        tay
        inc     str_confirm_erase0
        inc     str_confirm_erase0
        lda     char_space
        iny
        sta     str_confirm_erase0,y
        lda     char_question_mark
        iny
        sta     str_confirm_erase0,y
        rts
.endproc

;;; ============================================================

.proc append_to_confirm_erase1
        ptr := $06

        stxy    ptr
        ldy     #$00
        lda     (ptr),y
        pha
        tay
:       lda     (ptr),y
        sta     str_confirm_erase1_buf-1,y
        dey
        bne     :-
        pla
        clc
        adc     #kLenConfirmErase1
        sta     str_confirm_erase1
        tay
        inc     str_confirm_erase1
        inc     str_confirm_erase1
        lda     char_space
        iny
        sta     str_confirm_erase1,y
        lda     char_question_mark
        iny
        sta     str_confirm_erase1,y
        rts
.endproc

;;; ============================================================

.proc set_confirm_erase2_slot_drive
        txa
        and     #$70            ; Mask off slot
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #'0'
        sta     str_confirm_erase2  + kStrConfirmErase2SlotOffset
        txa
        and     #$80            ; Mask off drive
        asl     a               ; Shift to low bit
        rol     a
        adc     #'1'            ; Drive 1 or 2
        sta     str_confirm_erase2 + kStrConfirmErase2DriveOffset
        rts
.endproc

;;; ============================================================

.proc set_confirm_erase3_slot_drive
        txa
        and     #$70            ; Mask off slot
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        clc
        adc     #'0'
        sta     str_confirm_erase3 + kStrConfirmErase3SlotOffset
        txa
        and     #$80            ; Mask off drive
        asl     a               ; Shift to low bit
        rol     a
        adc     #'1'            ; Drive 1 or 2
        sta     str_confirm_erase3 + kStrConfirmErase3DriveOffset
        rts
.endproc

;;; ============================================================

LF185:  sty     LD41D
        tya
        jsr     disk_copy_overlay4_L0EB2
        beq     :+
        sta     LD41E
:       rts

.proc LF192
        lda     LD41D
        sta     disk_copy_overlay4_on_line_params_unit_num
        jsr     disk_copy_overlay4_L129B
        beq     done
        cmp     #ERR_NOT_PRODOS_VOLUME
        beq     done
        lda     disk_copy_overlay4_on_line_buffer
        and     #$0F
        bne     done
        lda     disk_copy_overlay4_on_line_buffer+1
        cmp     #ERR_NOT_PRODOS_VOLUME
        beq     done
        MGTK_RELAY_CALL2 MGTK::GetEvent, event_params
        lda     event_kind
        cmp     #MGTK::EventKind::key_down
        bne     LF192
        lda     event_key
        cmp     #CHAR_ESCAPE
        bne     LF192
        return  #$80

done:   return  #$00
.endproc

LF1CC:  cmp     #$03
        bcc     LF1D7
        cmp     #$06
        bcs     LF1D7
        jsr     disk_copy_overlay4_bell
LF1D7:  rts

.endproc

show_alert_dialog := alert_dialog::show_alert_dialog

;;; ============================================================

        PAD_TO $F200

.endproc
        disk_copy_overlay3_start := disk_copy_overlay3::start
