// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import './lib/base64.sol';
import "./IFaceDescriptor.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FaceDescriptor is IFaceDescriptor {
    struct Color {
        string value;
        string name;
    }
    struct Trait {
        string content;
        string name;
        Color color;
    }
    struct Face {
        uint256[5] colors;
        Trait hair;
        Trait eyebrow;
        Trait eyes;
        Trait nose;
        Trait mouth;
        Color background;
    }
    using Strings for uint256;

    string private constant SVG_END_TAG = '</svg>';

    function tokenURI(uint256 tokenId, uint256 seed) external pure override returns (string memory) {
        Face memory face = generateFace(seed);
        string memory colorCount = calculateColorCount(face.colors);

        string memory rawSvg = string(
            abi.encodePacked(
                '<svg width="320" height="320" viewBox="0 0 320 320" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="100%" height="100%" fill="', face.background.value,'"/>',
                '<text x="160" y="130" font-family="Courier,monospace" font-weight="700" font-size="20" text-anchor="middle" letter-spacing="1">',
                face.hair.content,
                face.eyebrow.content,
                face.eyes.content,
                face.nose.content,
                face.mouth.content,
                '</text>',
                SVG_END_TAG
            )
        );

        string memory encodedSvg = Base64.encode(bytes(rawSvg));
        string memory description = 'ASCII Faces, 9,999 randomly generated on-chain ASCII faces on the Ethereum network.';

        string memory json = encodeTokenJson(tokenId, face, colorCount, description, encodedSvg);

        return string(abi.encodePacked(
            'data:application/json;base64,',
            Base64.encode(bytes(json))
        ));
    }

    function generateFace(uint256 seed) internal pure returns (Face memory) {
        uint256[5] memory colors = [extractSeed(seed, 13, 14) % 20 + 1, extractSeed(seed, 15, 16) % 20 + 1, extractSeed(seed, 17, 18) % 20 + 1, extractSeed(seed, 19, 20) % 20 + 1, extractSeed(seed, 21, 22) % 20 + 1];
        Trait memory hair = getHair(extractSeed(seed, 1, 2) % 7 + 1, colors[0]);
        Trait memory eyebrow = getEyebrow(extractSeed(seed, 3, 4) % 6 + 1, colors[1]);
        Trait memory eyes = getEyes(extractSeed(seed, 5, 6) % 7 + 1, colors[2]);
        Trait memory nose = getNose(extractSeed(seed, 7, 8) % 2 + 1, colors[3]);
        Trait memory mouth = getMouth(extractSeed(seed, 9, 10) % 3 + 1, colors[4]);
        Color memory background = getBackground(extractSeed(seed, 11, 12) % 6 + 1);
        
        return Face(colors, hair, eyebrow, eyes, nose, mouth, background);
    }

    function encodeTokenJson(uint256 tokenId, Face memory face, string memory colorCount, string memory description, string memory encodedSvg) internal pure returns (string memory) {
        string memory json = string(abi.encodePacked(
            '{',
            '"name":"ASCII Face #', tokenId.toString(), '",',
            '"description":"', description, '",',
            '"image": "', 'data:image/svg+xml;base64,', encodedSvg, '",',
            '"attributes": [{"trait_type": "Hair", "value": "', face.hair.name,' (',face.hair.color.name,')', '"},',
            '{"trait_type": "Eyebrows", "value": "', face.eyebrow.name,' (',face.eyebrow.color.name,')', '"},',
            '{"trait_type": "Eyes", "value": "', face.eyes.name,' (',face.eyes.color.name,')', '"},'
        ));
        return encodeTokenJson2(json, face, colorCount);
    }

    function encodeTokenJson2(string memory json1, Face memory face, string memory colorCount) internal pure returns (string memory) {
        string memory json = string(abi.encodePacked(
            json1,
            '{"trait_type": "Nose", "value": "', face.nose.name,' (',face.nose.color.name,')', '"},',
            '{"trait_type": "Mouth", "value": "', face.mouth.name,' (',face.mouth.color.name,')', '"},',
            '{"trait_type": "Colors", "value": ', colorCount, '}',
            ']',
            '}'
        ));
        return json;
    }

    function getBackground(uint256 seed) private pure returns (Color memory) {
        if (seed == 1) {
            return Color("#4287f5", "Blue");
        }
        if (seed == 2) {
            return Color("#eb02f7", "Purple");
        }
        if (seed == 3) {
            return Color("#0dff00", "Green");
        }
        if (seed == 4) {
            return Color("#faea05", "Yellow");
        }
        if (seed == 5) {
            return Color("#f0230c", "Red");
        }
        if (seed == 6) {
            return Color("#f20069", "Pink");
        }
        return Color('','');
    }

    function getColor(uint256 seed) private pure returns (Color memory) {
        if (seed == 1) {
            return Color("#e60049", "UA Red");
        }
        if (seed == 2) {
            return Color("#82b6b9", "Pewter Blue");
        }
        if (seed == 3) {
            return Color("#b3d4ff", "Pale Blue");
        }
        if (seed == 4) {
            return Color("#00ffff", "Aqua");
        }
        if (seed == 5) {
            return Color("#0bb4ff", "Blue Bolt");
        }
        if (seed == 6) {
            return Color("#1853ff", "Blue RYB");
        }
        if (seed == 7) {
            return Color("#35d435", "Lime Green");
        }
        if (seed == 8) {
            return Color("#61ff75", "Screamin Green");
        }
        if (seed == 9) {
            return Color("#00bfa0", "Caribbean Green");
        }
        if (seed == 10) {
            return Color("#ffa300", "Orange");
        }
        if (seed == 11) {
            return Color("#fd7f6f", "Coral Reef");
        }
        if (seed == 12) {
            return Color("#d0f400", "Volt");
        }
        if (seed == 13) {
            return Color("#9b19f5", "Purple X11");
        }
        if (seed == 14) {
            return Color("#dc0ab4", "Deep Magenta");
        }
        if (seed == 15) {
            return Color("#f46a9b", "Cyclamen");
        }
        if (seed == 16) {
            return Color("#bd7ebe", "African Violet");
        }
        if (seed == 17) {
            return Color("#fdcce5", "Classic Rose");
        }
        if (seed == 18) {
            return Color("#FCE74C", "Gargoyle Gas");
        }
        if (seed == 19) {
            return Color("#eeeeee", "Bright Gray");
        }
        if (seed == 20) {
            return Color("#7f766d", "Sonic Silver");
        }

        return Color('','');
    }

    function getHair(uint256 seed, uint256 colorSeed) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 1) {
            content = "//-\\\\";
            name = "Hair";
        }
        if (seed == 2) {
            content = "+++++";
            name = "Trimmed";
        }
        if (seed == 3) {
            content = "^^^^^";
            name = "Punk";
        }
        if (seed == 4) {
            content = "=-=-=";
            name = "Wavey";
        }
        if (seed == 5) {
            content = "*****";
            name = "Sharp";
        }
        if (seed == 6) {
            content = "#####";
            name = "Spikey";
        }
        if (seed == 7) {
            content = "~~~~~";
            name = "Curly";
        }

        return Trait(string(abi.encodePacked('<tspan fill="', color.value, '">', content, '</tspan>')), name, color);
    }

    function getEyebrow(uint256 seed, uint256 colorSeed) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 1) {
            content = "|^   ^|";
            name = "Surprised";
        }
        if (seed == 2) {
            content = "|-   -|";
            name = "Normal";
        }
        if (seed == 3) {
            content = "|`   `|";
            name = "Small";
        }
        if (seed == 4) {
            content = "|`   `|";
            name = "Suspicious";
        }
        if (seed == 5) {
            content = "|'   '|";
            name = "High";
        }
        if (seed == 6) {
            content = "|_   _|";
            name = "Low";
        }

        return Trait(string(abi.encodePacked('<tspan dy="20" x="160" fill="', color.value, '">', content, '</tspan>')), name, color);
    }

    function getEyes(uint256 seed, uint256 colorSeed) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        if (seed == 1) {
            content = "|O   O|";
            name = "Eyes";
        }
        if (seed == 2) {
            content = "|*   *|";
            name = "Eyes";
        }
        if (seed == 3) {
            content = "()   ()";
            name = "Eyes";
        }
        if (seed == 4) {
            content = "|@   @|";
            name = "Surprised";
        }
        if (seed == 5) {
            content = "|x   x|";
            name = "Surprised";
        }
        if (seed == 6) {
            content = "|-   O|";
            name = "Surprised";
        }
        if (seed == 7) {
            content = "|.   .|";
            name = "Surprised";
        }

        return Trait(string(abi.encodePacked('<tspan dy="25" x="160" fill="', color.value, '">', content, '</tspan>')), name, color);
    }

    function getNose(uint256 seed, uint256 colorSeed) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        uint256 y;
        if (seed == 1) {
            content = "|  ~  |";
            name = "Crooked";
            y = 25;
        }
        if (seed == 2) {
            content = "|  .  |";
            name = "Small";
            y = 22;
        }

        return Trait(string(abi.encodePacked('<tspan dy="',y.toString(),'" x="160" fill="', color.value, '">', content, '</tspan>')), name, color);
    }

    function getMouth(uint256 seed, uint256 colorSeed) private pure returns (Trait memory) {
        Color memory color = getColor(colorSeed);
        string memory content;
        string memory name;
        uint256 y;
        if (seed == 1) {
            content = "\\_O_/";
            name = "Open";
            y = 25;
        }
        if (seed == 2) {
            content = "\\_>_/";
            name = "Kissing";
            y = 22;
        }
        if (seed == 3) {
            content = "\\_n_/";
            name = "Kissing";
            y = 22;
        }

        return Trait(string(abi.encodePacked('<tspan dy="',y.toString(),'" x="160" fill="', color.value, '">', content, '</tspan>')), name, color);
    }

    //TODO test
    function calculateColorCount(uint256[5] memory colors) private pure returns (string memory) {
        uint256 count;
        for (uint256 i = 0; i < 5; i++) {
            for (uint256 j = 0; j < 5; j++) {
                if (colors[i] == colors[j]) {
                    count++;
                }
            }
        }

         if (count == 5) {
            return '5';
        }
        if (count == 4) {
            return '4';
        }
        if (count == 6) {
            return '3';
        }
        if (count == 8 || count == 10) {
            return '2';
        }
        if (count == 16) {
            return '1';
        }

        return '0';
    }

    function extractSeed(uint256 seed, uint256 digit1Position, uint256 digit2Position) private pure returns (uint256) {
        uint256 divisor = 10**(22 - digit1Position);
        uint256 extractedDigit1 = (seed / divisor) % 10;

        divisor = 10**(22 - digit2Position);
        uint256 extractedDigit2 = (seed / divisor) % 10;

        uint256 extractedSeed = extractedDigit1 * 10 + extractedDigit2;
        return extractedSeed;
    }
}