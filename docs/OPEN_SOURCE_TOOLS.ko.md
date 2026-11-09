# KnightFighter2 오픈소스 도구 설치와 활용 안내

확인일: 2026년 11월 9일. Windows 환경의 KnightFighter2 프로젝트에서 사용할 도구 7종을 설치했다. 맵 제작은 LDtk 또는 Ogmo, 절차적 지형은 Gaea, 캐릭터 제작은 SpriteKiln, 픽셀 그래픽은 Pixelbolt, 전투 효과는 pixelfx를 사용하고 이동과 충돌 구현은 Godot 공식 플랫폼 예제를 참고한다.

이 문서가 설치 위치와 사용법의 기준이다. 다음 작업부터 “오픈소스 도구 문서 참고해서 검격 효과 만들어줘”처럼 요청하면 된다. 프로젝트의 `AGENTS.md`에도 이 문서를 읽도록 연결했다.

## 설치 현황

프로젝트 루트 기준 상대 경로다. 정확한 소스 커밋, 설치 파일 SHA256과 출처는 [`tools/open-source.lock.json`](../tools/open-source.lock.json)에 기록한다.

| 도구 | 설치 버전 | 설치 위치 | 현재 사용할 수 있는 범위 |
|---|---|---|---|
| [Gaea](https://github.com/gaea-godot/gaea) | v1.4.1 릴리스 | `addons/gaea`, 원본 `tools/gaea` | Godot 애드온 활성화, 절차적 생성 노드 사용 |
| [LDtk](https://github.com/deepnight/ldtk) | 1.5.3 | `%LOCALAPPDATA%\Programs\LDtk\LDtk.exe` | 외부 맵 편집기 설치 |
| [Godot Platformer 2D](https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer) | master의 고정 커밋 | `tools/godot-demo-projects/2d/platformer` | 별도 Godot 프로젝트로 실행하고 코드 참고 |
| [Ogmo Editor 3 CE](https://github.com/Ogmo-Editor-3/OgmoEditor3-CE) | 3.4.0 | `tools/ogmo/Ogmo Editor/Ogmo Editor.exe` | 외부 맵 편집기 설치, 원본 `tools/ogmo-source` |
| [SpriteKiln](https://github.com/LucasJRamos/spritekiln/blob/main/README.ko.md) | 0.3.0 | `tools/spritekiln-venv`, 원본 `tools/spritekiln` | Python 격리 환경, MCP·고속 렌더러 패키지, Godot 애드온 설치 |
| [Pixelbolt](https://github.com/skulitom/Pixelbolt) | 0.14.0 | `tools/pixelbolt` | CLI와 로컬 Studio 실행 가능, 추가 npm 의존성 없음 |
| [pixelfx](https://github.com/patch-gg/pixelfx) | 0.3.0 | `tools/pixelfx` | 효과 렌더링, PNG 시트와 JSON 내보내기, 갤러리 실행 |

Gaea는 upstream에서 안정판으로 안내하는 1.x 릴리스를 선택했다. 릴리스 태그는 v1.4.1이지만 포함된 `plugin.cfg`의 버전 표기는 1.4.0이다. 기본 브랜치 2.0과 API가 다르므로 설치된 1.x 코드와 예제를 기준으로 사용한다. 최초 링크의 `gaeautm_source=chatgpt.com`은 `gaea-godot/gaea`로 바로잡았다.

LDtk와 Ogmo는 Godot 플러그인이 아니다. 편집과 저장은 가능하지만 `.ldtk` 또는 Ogmo 레벨 JSON을 게임의 TileMapLayer, 충돌, 적 스폰으로 변환하는 로더는 아직 구현하지 않았다. 실제 스테이지 제작 시 편집기 하나를 정하고 해당 로더를 구현한다.

## 공통 실행 방법

프로젝트 루트의 PowerShell에서 실행한다. 가상 환경 활성화나 전역 PATH 변경 없이 사용할 수 있다.

```powershell
# 목록과 안내서 열기
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 List
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Guide

# 맵 편집기와 Godot 프로젝트
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 LDtk
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Ogmo
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Platformer
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Gaea

# SpriteKiln 설치 확인
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 SpriteKiln --version

# Pixelbolt Studio 서버 실행
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Pixelbolt preview --port 8091

# pixelfx 갤러리 서버 실행
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 PixelFXGallery 8080
```

Studio는 `http://127.0.0.1:8091/`, 갤러리는 `http://localhost:8080/gallery/`로 접속한다. 서버를 실행한 터미널에서 `Ctrl+C`로 종료한다. GUI 도구는 실행기로 호출하면 별도 창이 열린다.

Godot 4.7.2 실행 파일 경로는 로컬 설정 `tools/.local-tools.json`의 `godot` 항목에 저장되어 있다. Godot 위치가 바뀌면 이 항목을 수정한다. LDtk는 위 사용자별 기본 설치 위치를 사용한다.

## 작업에 맞는 도구 선택

| 만들 작업 | 우선 사용할 도구 | 게임에 적용하는 방법 |
|---|---|---|
| 수작업 스테이지, 타일, 발판, 적 배치 | LDtk 또는 Ogmo | 원본 맵을 `art/maps/`에 보관하고 전용 로더로 Godot 씬 생성 |
| 무작위 던전, 지형, 반복 플레이용 맵 | Gaea | 생성기와 렌더러를 씬에 배치하고 TileSet·시드·충돌 규칙 연결 |
| 이동, 점프, 경사면, 카메라, 이동 발판 | 공식 Platformer 2D | 관련 GDScript와 씬 구조를 읽고 우리 프로젝트 구조에 맞춰 적용 |
| 기사와 적 캐릭터, 무기, 프레임 애니메이션 | SpriteKiln | YAML 원본 → 포즈 검토 → 렌더 → Godot SpriteFrames와 씬 내보내기 |
| 타일셋, 아이콘, 소품, 독자적인 픽셀 애니메이션 | Pixelbolt | JSON 레시피 → 검증·렌더 → PNG·atlas·Godot `.tres` 사용 |
| 검격, 피격, 화염, 마법, 대시, UI 효과 | pixelfx | 카탈로그에서 효과 선택 → PNG 시트·JSON 출력 → Godot 애니메이션 구성 |

처음 실제 캐릭터를 만들 때 화면에서의 크기, 측면·탑다운 시점, 팔레트와 애니메이션 방향을 정한다. `spritekiln.toml`에는 초기화 기본값만 있으며 게임 아트 스타일은 아직 확정하지 않았다. 설치 확인용 포즈는 게임 자산으로 채택한 것이 아니다.

## 도구별 사용법

### Gaea

`project.godot`에서 `res://addons/gaea/plugin.cfg`를 활성화했다. Godot의 프로젝트 설정 → 플러그인에서 상태를 확인한다. 설치된 생성기·렌더러·수정자는 `addons/gaea/`에 있으며, 사용 예제는 `tools/gaea/scenes/`에서 찾는다.

먼저 작은 테스트 씬에서 생성기 하나와 렌더러를 연결하고 TileSet과 시드를 고정해 결과를 확인한다. 맵 시드, 시작 지점, 도달 가능한 발판과 충돌 검사는 게임 요구에 맞춰 추가한다. 원본 프로젝트의 다른 애드온은 설치하지 않았다. [원본 설치 안내](https://github.com/gaea-godot/gaea/tree/v1.4.1)

### LDtk와 Ogmo

LDtk는 [공식 v1.5.3 Windows 설치 파일](https://github.com/deepnight/ldtk/releases/tag/v1.5.3), Ogmo는 upstream README가 연결하는 [공식 배포 페이지](https://ogmoeditor.itch.io/editor)의 Windows ZIP을 사용했다. Ogmo의 GitHub 릴리스에는 실행 파일이 없어 itch.io 배포본을 받았다.

맵을 만들 때 타일 크기, 충돌 레이어, 플레이어 시작점, 적·아이템 엔티티 필드를 먼저 정한다. LDtk와 Ogmo의 원본 맵 형식을 동시에 섞지 않는다. LDtk 소스는 `tools/ldtk-source`에 루트 파일과 `docs/`만 받았으며, 설치된 편집기는 별도 실행 파일이다. Ogmo 전체 소스는 `tools/ogmo-source`에 있다.

### Godot 공식 플랫폼 예제

공식 저장소에서 `2d/platformer`를 sparse checkout하여 관련 예제만 확보했다. `Platformer` 실행 명령으로 별도 프로젝트를 연 뒤 F6 또는 F5로 살펴본다. `project.godot`의 메인 씬은 `game_singleplayer.tscn`이다. 이동·경사면·발판·카메라 관련 코드를 가져올 때 입력 액션과 노드 경로도 함께 확인한다.

예제의 Compatibility 렌더러와 본 프로젝트의 Mobile 렌더러 설정은 다르다. 예제 전체의 프로젝트 설정을 덮어쓰지 않고 필요한 로직을 적용한다. [공식 설명](https://github.com/godotengine/godot-demo-projects/tree/master/2d/platformer)

### SpriteKiln

`spritekiln.toml`을 초기화했고 Godot 런타임 애드온 `addons/spritekiln`도 활성화했다. 제작 원본은 `art/specs/`, 게임 내보내기는 `assets/spritekiln/`을 사용한다. 작업 지침은 `.spritekiln/agent/`에 설치되어 있다.

아트 스타일을 정한 뒤의 기본 작업 흐름은 다음과 같다. `<spec.yaml>`은 실제 원본 경로로 바꾼다.

```powershell
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 SpriteKiln style
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 SpriteKiln validate <spec.yaml>
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 SpriteKiln pose <spec.yaml> --dirs all
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 SpriteKiln render <spec.yaml> --export
```

렌더 중간 결과는 직접 수정하지 않고 YAML을 고친다. MCP 서버 패키지도 설치했지만 Codex 전역 설정에는 서버를 등록하지 않았다. 현재 세션과 다음 작업에서는 공통 실행기로 동일한 CLI 기능을 사용한다. [한국어 안내](https://github.com/LucasJRamos/spritekiln/blob/main/README.ko.md)

### Pixelbolt

원본 JSON을 `art/pixelbolt/`에 두고 결과를 `assets/pixelbolt/`로 내보낸다. 아래는 설치된 공식 예제로 출력을 확인하는 명령이다.

```powershell
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Pixelbolt validate tools/pixelbolt/examples/forest-spirit.json
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Pixelbolt render tools/pixelbolt/examples/forest-spirit.json --out tools/verification/pixelbolt
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 Pixelbolt help presets
```

새 레시피 작성 시 `tools/pixelbolt/docs/agent-quick-start.md`를 먼저 읽는다. 출력의 `.tres`는 Godot SpriteFrames로 사용한다. MCP 서버 소스도 포함하지만 자동 연결은 하지 않았으며 CLI와 Studio로 바로 사용할 수 있다. [공식 사용법](https://github.com/skulitom/Pixelbolt#readme)

### pixelfx

`tools/pixelfx/docs/CATALOG.md`에서 효과 ID를 찾는다. 예를 들어 검격 시트를 출력하려면 다음을 실행한다.

```powershell
powershell -ExecutionPolicy Bypass -File tools/open-source.ps1 PixelFX melee/sword-slash --sheet --no-actor --out tools/verification/pixelfx
```

PNG 시트와 Aseprite 스타일 JSON이 만들어진다. 실제 채택할 효과는 출력 위치를 `assets/vfx/`로 바꾸고, JSON의 프레임 크기·길이·pivot을 반영해 AnimatedSprite2D를 구성한다. Aseprite용 Godot 임포터는 이번에 추가하지 않았다. PNG 시트는 직접 프레임을 잘라 사용할 수 있다. GIF·MP4 출력에는 ffmpeg가 필요할 수 있으며 PNG 시트 출력에는 필요 없다. [공식 내보내기 안내](https://github.com/patch-gg/pixelfx#use-one)

## 검증 결과

| 항목 | 확인 결과와 근거 |
|---|---|
| LDtk와 Ogmo | 실행 파일 버전 1.5.3·3.4.0 확인, 각각 시작 후 4초 동안 프로세스 유지. `tools/verification/startup-results.json` |
| Gaea와 SpriteKiln 애드온 | Godot 4.7.2에서 활성화 후 headless editor import 종료 코드 0, `SCRIPT ERROR`·`ERROR:` 없음. `tools/verification-godot-enabled.log` |
| 공식 Platformer | headless import 및 120프레임 실행 종료 코드 0, 스크립트 오류 없음. 예제 폴더의 `platformer-import.log`, `platformer-run.log` |
| SpriteKiln | 0.3.0 확인, `pip check` 통과, CC0 측면 템플릿 validate·포즈 PNG 생성 성공. `tools/verification/spritekiln/side_humanoid.png` |
| Pixelbolt | forest-spirit 검증·렌더 성공, PNG·atlas·Godot `.tres` 출력. `tools/verification/pixelbolt/` |
| pixelfx | sword-slash 24프레임 PNG 시트·JSON 출력 성공. `tools/verification/pixelfx/melee/sword-slash/` |
| Studio와 갤러리 | 각 로컬 웹서버 시작 후 HTTP 200 응답 확인. `tools/verification/startup-results.json` |
| 공통 실행기 | 목록, SpriteKiln 버전·포즈, Pixelbolt 검증, pixelfx 출력과 옵션 전달 확인 |

설치 검증은 완성된 게임플레이나 맵 로더 검증을 의미하지 않는다. LDtk·Ogmo의 실제 맵 제작, 고속 렌더러의 속도, 효과의 게임 안에서의 타이밍은 해당 기능을 제작할 때 검증한다.

## 저장 위치와 라이선스

`tools/.gdignore`가 외부 저장소·Python 환경·설치 파일을 Godot 임포트에서 제외한다. `.gitignore`는 로컬 도구를 제외하고 실행기와 설치 기록을 보존한다. `addons/`는 게임 프로젝트에 포함하며, `art/`의 제작 원본과 `assets/`의 채택한 출력도 버전 관리한다.

도구 코드는 MIT이며 원본 라이선스를 각 소스 폴더에 유지했다. Gaea와 SpriteKiln의 프로젝트 복사본에도 LICENSE를 포함했다. 자산을 배포할 때는 코드 라이선스 외에 개별 자산의 조건도 확인한다.

특히 [SpriteKiln 라이선스](https://github.com/LucasJRamos/spritekiln/blob/main/LICENSE)는 코드·문서·통합은 MIT, 예제·템플릿 등은 CC0로 구분하고, **Templar와 Huntress 등 Hunt Tower 쇼케이스 자산은 재사용을 허용하지 않는다.** 쇼케이스를 게임에 복사하지 않고 CC0 템플릿 또는 직접 작성한 사양으로 제작한다. 공식 플랫폼 예제의 음악 등 외부 자산도 해당 크레딧을 함께 보존한다.

## 재설치와 업데이트

이 PC의 도구는 설치되어 있다. 새 PC에서는 저장소의 실행기·문서만 복사해도 로컬 소스와 실행 파일이 함께 복원되지는 않는다. 설치 기록의 `repository`, `commit`, `download_url`을 사용해 같은 버전을 준비한다.

```powershell
# 소스 복원 예시: commit은 open-source.lock.json의 해당 값을 사용
git clone https://github.com/skulitom/Pixelbolt.git tools/pixelbolt
git -C tools/pixelbolt checkout <commit>

# SpriteKiln 소스를 복원한 뒤 격리 환경 재설치
python -m venv tools/spritekiln-venv
tools/spritekiln-venv/Scripts/python.exe -m pip install "./tools/spritekiln[mcp,fast]"
```

Python 의존성의 현재 스냅샷은 로컬 `tools/spritekiln-requirements.lock.txt`에 있다. Node.js 20 이상과 Python 3.10 이상이 필요하며, 현재 검증 환경은 Node 22.20.0과 Python 3.13.7이다.

LDtk는 기록된 공식 설치 파일로 사용자별 설치하고, Ogmo Windows ZIP은 `tools/ogmo/`에 푼다. Gaea는 고정 버전의 `addons/gaea`와 LICENSE를, SpriteKiln은 `integrations/godot/addons/spritekiln`을 프로젝트에 복사한다. 애드온 업데이트는 원본을 먼저 별도 위치에서 검증한 다음 반영한다.

업데이트 후에는 이 문서와 설치 기록을 함께 갱신하고, Godot 애드온 import 및 대표 이미지 출력을 다시 확인한다. Gaea 2.0 전환과 LDtk·Ogmo 로더 추가는 각각 별도 구현 작업으로 진행한다.
