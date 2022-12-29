Notes c/o @frankmilliron:


# Convert Mac Icons to A2D Style Icons


* Install X-Code command line tools (working on macOS 12.6.1 "Monterey")
* Use `DeRez filename` to extract resources. Output will be text in the Terminal window. Copy (or pipe) text to file. ICON and CURS entries are black-and-white icons and cursors, respectively. Output for each entry will look similar to this:

```
data 'ICON' (-15972, "sleep2") {
    $"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
    $"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
    $"0000 0000 01F8 0000 0010 0000 0060 7800"            /* .....?.......`x. */
    $"0040 1100 01F8 2280 0001 7C80 0002 8880"            /* .@...?"?..|?..?? */
    $"0004 F8C0 0038 50A0 00C8 3050 0110 0030"            /* ..??.8P?.?0P...0 */
    $"0110 0030 0210 0038 0410 00A8 040B 8128"            /* ...0...8...?..?( */
    $"0408 622C 0408 1054 0404 05B4 0203 FE64"            /* ..b,...T...?..?d */
    $"01F8 1E4C 000F F3F8 0000 0000 0000 0000"            /* .?.L..??........ */
};
```

* Use "Sublime Text" to strip extras and break bytes into groups of 8-bits. (Select-All then Command-Shift-L to select every line. Control-K 'Edit-->Text-->Delete to End' to clear to end of the line)

```
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 01 F8 00 00 00 10 00 00 00 60 78 00
00 40 11 00 01 F8 22 80 00 01 7C 80 00 02 88 80
00 04 F8 C0 00 38 50 A0 00 C8 30 50 01 10 00 30
01 10 00 30 02 10 00 38 04 10 00 A8 04 0B 81 28
04 08 62 2C 04 08 10 54 04 04 05 B4 02 03 FE 64
01 F8 1E 4C 00 0F F3 F8 00 00 00 00 00 00 00 00
```

* Run the bytes through a hexadecimal to binary converter. I used the following website:
https://www.345tool.com/converter/hex-to-binary-converter (make sure "Pad Leading Zeros" is checked)
* Then remove all line endings from the resulting binary bitstream
* Break into lines of 32x32 characters

```
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000001111110000000000000000000
00000000000100000000000000000000
00000000011000000111100000000000
00000000010000000001000100000000
00000001111110000010001010000000
00000000000000010111110010000000
00000000000000101000100010000000
00000000000001001111100011000000
00000000001110000101000010100000
00000000110010000011000001010000
00000001000100000000000000110000
00000001000100000000000000110000
00000010000100000000000000111000
00000100000100000000000010101000
00000100000010111000000100101000
00000100000010000110001000101100
00000100000010000001000001010100
00000100000001000000010110110100
00000010000000111111111001100100
00000001111110000001111001001100
00000000000011111111001111111000
00000000000000000000000000000000
00000000000000000000000000000000
```

* And add entries for the A2D conversion macro "PX" in groups of 7. If any groups are less than 7, pad until there are 7.

```
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%1111110),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000100),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0011000),PX(%0001111),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0010000),PX(%0000010),PX(%0010000),PX(%0000000)
        .byte   PX(%0000000),PX(%1111110),PX(%0000100),PX(%0101000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0101111),PX(%1001000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%1010001),PX(%0001000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000001),PX(%0011111),PX(%0001100),PX(%0000000)
        .byte   PX(%0000000),PX(%0001110),PX(%0001010),PX(%0001010),PX(%0000000)
        .byte   PX(%0000000),PX(%0110010),PX(%0000110),PX(%0000101),PX(%0000000)
        .byte   PX(%0000000),PX(%1000100),PX(%0000000),PX(%0000011),PX(%0000000)
        .byte   PX(%0000000),PX(%1000100),PX(%0000000),PX(%0000011),PX(%0000000)
        .byte   PX(%0000001),PX(%0000100),PX(%0000000),PX(%0000011),PX(%1000000)
        .byte   PX(%0000010),PX(%0000100),PX(%0000000),PX(%0001010),PX(%1000000)
        .byte   PX(%0000010),PX(%0000010),PX(%1110000),PX(%0010010),PX(%1000000)
        .byte   PX(%0000010),PX(%0000010),PX(%0001100),PX(%0100010),PX(%1100000)
        .byte   PX(%0000010),PX(%0000010),PX(%0000010),PX(%0000101),PX(%0100000)
        .byte   PX(%0000010),PX(%0000001),PX(%0000000),PX(%1011011),PX(%0100000)
        .byte   PX(%0000001),PX(%0000000),PX(%1111111),PX(%1100110),PX(%0100000)
        .byte   PX(%0000000),PX(%1111110),PX(%0000011),PX(%1100100),PX(%1100000)
        .byte   PX(%0000000),PX(%0000011),PX(%1111110),PX(%0111111),PX(%1000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
        .byte   PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000),PX(%0000000)
```

* If we do this again, tools to automated can be easily created. Just ask!

# Compression

LZSA Source and docs at: https://github.com/emmanuel-marty/lzsa

Frames were converted using:

./lzsa -r -f2 neko_frame_01.bin neko_frame_01.bin.lzsa