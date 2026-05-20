import os
import json

# 피그마에서 추출한 색상 데이터
color_data = {
    "Blue": {
        "blue00": "#F3F7FA", "blue01": "#EDF2F7", "blue02": "#DAE5EF",
        "blue03": "#88AACC", "blue04": "#7A99B8", "blue05": "#6D88A3",
        "blue06": "#668099", "blue07": "#52667A", "blue08": "#3D4C5C", "blue09": "#303B47"
    },
    "Purple": {
        "purple00": "#F0E7FB", "purple01": "#E8DBF9", "purple02": "#CFB4F3",
        "purple03": "#650ED8", "purple04": "#5B0DC2", "purple05": "#510BAD",
        "purple06": "#4C0BA2", "purple07": "#3D0882", "purple08": "#2D0661", "purple09": "#23054C"
    },
    "Grey": {
        "gray00": "#F2F2F2", "gray01": "#EBEBEB", "gray02": "#D5D5D5",
        "gray03": "#787878", "gray04": "#6C6C6C", "gray05": "#606060",
        "gray06": "#5A5A5A", "gray07": "#484848", "gray08": "#363636", "gray09": "#2A2A2A"
    },
    "WhiteBlack": {
        "white": "#FFFFFF", "black": "#000000"
    }
}

base_dir = "Colors.xcassets"

# 루트 폴더 Contents.json 생성
os.makedirs(base_dir, exist_ok=True)
with open(os.path.join(base_dir, "Contents.json"), "w") as f:
    json.dump({"info": {"author": "xcode", "version": 1}}, f, indent=2)

for category, colors in color_data.items():
    category_dir = os.path.join(base_dir, category)
    os.makedirs(category_dir, exist_ok=True)
    
    # 폴더 속성(Provides Namespace) 설정 json
    with open(os.path.join(category_dir, "Contents.json"), "w") as f:
        json.dump({"info": {"author": "xcode", "version": 1}, "properties": {"provides-namespace": False}}, f, indent=2)

    for color_name, hex_code in colors.items():
        color_dir = os.path.join(category_dir, f"{color_name}.colorset")
        os.makedirs(color_dir, exist_ok=True)
        
        # Hex 문자열 처리 (예: #F3F7FA -> F3, F7, FA)
        hex_str = hex_code.lstrip('#')
        r, g, b = f"0x{hex_str[0:2]}", f"0x{hex_str[2:4]}", f"0x{hex_str[4:6]}"
        
        # Xcode Asset Catalog용 JSON 구조
        contents = {
            "colors": [{
                "color": {
                    "color-space": "srgb",
                    "components": { "alpha": "1.000", "red": r, "green": g, "blue": b }
                },
                "idiom": "universal"
            }],
            "info": { "author": "xcode", "version": 1 }
        }
        
        with open(os.path.join(color_dir, "Contents.json"), "w") as f:
            json.dump(contents, f, indent=2)

print("성공! Colors.xcassets가 생성되었습니다.")
