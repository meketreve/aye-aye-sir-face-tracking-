# STATUS — aye-aye-sir ( face tracking )

> Single source of truth for resuming work. Read this FIRST when starting a session.
> Last updated: 2026-06-01 (v0.1.0 released)

---

## ✅ Concluído

- **Plano** → `~/.claude/plans/lively-exploring-brooks.md`.
- **Deps instaladas** (Ubuntu 26.04): cmake, libobs-dev 32.1, libopencv-dev 4.10, obs-studio.
- **M1** — scaffold + filtro no-op. Builds `aye-aye-mask.so`, exporta `obs_module_*`, instala em `~/.config/obs-studio/plugins/aye-aye-mask/`. ✅
- **M2** — frame-grab (gs_stage_texture → cv::Mat) + tracker YuNet em thread worker + debug overlay (landmarks). Detecção YuNet validada FORA do OBS (Lena, score 0.91, colunas batem). ✅
- **M3** — pose solvePnP (`pose.cpp`) + quad de máscara projetado em perspectiva (`mask-renderer.cpp` + `data/effects/mask.effect`). Textura vem de outra source do OBS (imagem/vídeo). Compila, linka, instala. ✅
- **M4** — suavização (`smoothing.cpp`): One-Euro na translação + slerp adaptativo na rotação (cv::Quatd). Sliders "Rotation follow" (0=billboard, 1=3D total) e "Smoothing". ✅
- **M5** — perda de rosto: hold da última pose (`Hold on face loss`) + fade out (`Fade out`) + reset do smoother ao re-adquirir após gap >200ms. Locale pt-BR + README do projeto. ✅
- **FIX crash**: solvePnP ITERATIVE estourava (<6 pts) → trocado p/ SQPNP + try/catch. (commit b83117c)
- **✅ VALIDADO VISUAL (vídeo gravado):** orientação correta, máscara alinha e acompanha o rosto, sem crash. yaw+roll OK. flip default OK, handedness OK.
- **M7 (revertido)** — Facemark LBF 68pt deu jitter + roll pior (queixo do LBF ruidoso, alavanca alta). Revertido pra YuNet 5pt. (c6b64da)
- **M8** — rede de head-pose (onnxruntime): YuNet dá posição/escala (olhos), rede ONNX (yakhyo mobilenetv2, saída matriz R 3x3) dá rotação com pitch. Validado nos frames do vídeo do user (pitch +37 cima / -15 baixo). Build fiel: rebuild Rz·Ry·Rx = decomposição. Toggles invert pitch/yaw/roll. Dep: libonnxruntime-dev (instalado). Modelo 8.5MB fetch em build. (commit 6784b76)
  - ✅ **CONFIRMADO no OBS:** pitch/yaw/roll funcionam. Precisou inverter os 3 eixos → bakeado como default (commit ccd914c). Efeito FECHADO.
- **Windows/.exe** — CI verde, **`.exe` gerado e baixado** → `dist/aye-aye-mask-0.1.0-windows-x64-installer.exe` (34.5MB). Run `26754403755` success. ✅
  - CI usa OpenCV + onnxruntime PREBUILT (sem vcpkg), bundle das DLLs, libobs do source+import lib, NSIS. (commit c6af351 + fixes abaixo)
  - **4 fixes p/ CI verde** (1-6 jun): (1) header gerado é `obsconfig.h.in`→`obsconfig.h` SEM hífen (`obs-config.h` é outro, estático); (2) asset OBS = `OBS-Studio-<ver>-Windows.zip` SEM `-x64`; (3) `Ort::Session` quer ORTCHAR_T → path via `std::filesystem::path::c_str()` (headpose.cpp); (4) NSIS resolve `File` relativo ao dir do .nsi → stage em `installer/package`.
  - Artefatos no GitHub: `aye-aye-mask-windows-installer` (.exe) + `aye-aye-mask-windows-plugin` (zip).
  - **Runtime FIX Windows (bug-031):** máscara não aparecia no Windows (tracking+landmarks OK). Log OBS: `device_vertexbuffer_create (D3D11): Invalid texture vertex size specified`. D3D11 só aceita texcoord width 2/4 (GL aceitava 3). Padded p/ width 4 `(u/z,v/z,0,1/z)`, divide por `.w` no shader. `.exe` rebaixado (run `26755958058`).
  - ✅ Máscara visível confirmada no Windows após fix.
- **Anti-jitter (M9)** — slider **"Moving-average window"** (1–30 frames, 1=off). Pós-filtro boxcar sobre o estágio One-Euro/slerp em `smoothing.cpp`: ring buffer das últimas N poses, média na translação + média de quaternion (sign-aligned, normalizada) na rotação. Custo = latência ~N frames. `.exe` rebuild (run `26756921011`).
- **M10a — FaceMesh densa (468pt):** módulo `LandmarkNet` (onnxruntime) roda MediaPipe FaceMesh dentro da bbox do YuNet. Centros dos olhos vêm do mesh (mais estável que 5pt YuNet) → posição/escala da máscara mais firme. Rotação ainda da head-pose net. Toggle "Dense landmarks" (default on), debug desenha 468 pts. Modelo `face_landmark_468.onnx` (2.4MB, Apache, keijiro) via fetch-models.sh. **Validado em Python** (pts colam no rosto). Build Linux OK. Decisão: FaceMesh > dlib-68 (99MB + licença research-only).
  - ✅ Testado no Windows: precisão boa, jitter aceitável, user gostou do toggle denso/normal + média móvel.
- **M10b — modo mesh morph (deforma):** toggle **"Mesh morph"** (default off). Quad plano → triangle-list texturizado nos 468 pts ao vivo. `facemesh_tables.hpp` (gerado de `canonical_face_model.obj` via `scripts/gen-facemesh-tables.py`): triangulação canônica (898 tris) + **UV frontal** (qualquer imagem/vídeo cola como decal frontal). `mask.effect` ganhou técnica `DrawMesh` (uv float2). `MaskRenderer::render_mesh` + index buffer estático cacheado. Pontos suavizados por EMA (slider Smoothing). Build Linux OK.
  - ✅ Testado no Windows: mesh-morph funciona.
- **Startup fix (bug-032):** fonte da máscara não carregava no boot (resolução eager antes da source existir) → resolução LAZY por nome no render. Auto-carrega. ✅ confirmado pelo user.
- **🎉 RELEASE v0.1.0** — histórico achatado em 1 commit (`d4c9dc7`), force-push. README reescrito (install Windows via release + passo-a-passo Linux). Release publicada com o `.exe`: https://github.com/meketreve/aye-aye-sir-face-tracking-/releases/tag/v0.1.0
- **M6 (tooling)** — layout de install Windows no CMake (WIN32 → obs-plugins/64bit + data/obs-plugins). `installer/aye-aye-mask.nsi` (NSIS), `installer/build-and-package.ps1` (build MSVC+vcpkg → stage → makensis), `installer/README.md` (rotas A/B/C). ✅
  - ⏳ **o .exe em si** precisa de build MSVC no Windows (Route A) ou CI (Route C). Não dá p/ gerar .dll Windows no WSL.
  - ⏳ **falta validação VISUAL no OBS** (ver Teste abaixo).

---

## 🚀 Próxima fase

**Objetivo:** Instalar o `.exe` no OBS Windows e fazer validação VISUAL (máscara cola/segue/gira). Pitch/yaw/roll já confirmados no OBS Linux; falta confirmar no binário Windows.

> Build Windows = **FEITO via CI** (`.exe` em `dist/`). Rota local (`installer/build-and-package.ps1`) continua válida como alternativa. Próximo gargalo = só o teste visual no Windows.

### Teste Windows (USUÁRIO)
1. Rodar `dist\aye-aye-mask-0.1.0-windows-x64-installer.exe` (admin). Instala em `$PROGRAMFILES64\obs-studio\obs-plugins\64bit` + `data\obs-plugins\aye-aye-mask`.
2. Abrir OBS → source de rosto → filtro **Eye Mask Tracker** → escolher Image/Media Source como máscara.
3. Confirmar: landmarks colam, máscara cobre olhos, segue e gira em perspectiva.

### Teste (USUÁRIO, no WSLg)
1. `obs` (já instalado). Plugin já está instalado em `~/.config/obs-studio/plugins/`.
2. Criar **Media Source** com um vídeo de rosto (ou usbipd p/ webcam). Criar **Image Source** (PNG da máscara, com alpha).
3. No source do rosto → filtros → **Eye Mask Tracker**. Em "Mask source" escolher a Image Source.
4. Ligar **Debug: show tracked landmarks**. Confirmar que os pontos colam no rosto.
   - Se landmarks aparecem **de cabeça pra baixo / desalinhados** → ligar **Debug: flip readback** (backend GL pode entregar readback invertido). Esse é o 1º unknown a resolver.
5. Conferir: máscara cobre os olhos, segue posição, e **gira em perspectiva** ao virar a cabeça.

### Unknowns que o teste visual resolve (só ajuste, código compila)
- **flip_readback**: orientação do readback no GL (toggle existe).
- **handedness da rotação**: se a máscara inclina pro lado ERRADO ao virar → corrigir sinais no modelo 3D / conversão (pose.cpp).
- **blend de alpha**: hoje SRCALPHA/INVSRCALPHA (straight). Se máscara com alpha ficar com halo → mudar p/ premultiplicado.

### Próximos arquivos (M5)
| Tipo | Arquivo | Conteúdo |
|---|---|---|
| editar | `tracker.hpp`/`mask-filter.cpp` | timestamp na FaceResult; hold última pose boa por N ms; fade out da opacidade ao perder rosto; reset do smoother após perda longa |
| editar | `data/locale/*` | strings hold/fade |

### Rota do .exe (decidir)
- **A**: build no Windows (VS2022+vcpkg+NSIS) → `installer/build-and-package.ps1`.
- **C**: CI GitHub Actions gera o .exe (precisa `git init` + push). Posso montar `.github/workflows/windows.yml`.

---

## 📁 Arquitetura ativa

- **Stack:** libobs 32.1 video filter (C++20) + OpenCV 4.10.
- **Pipeline:** video_render → (throttle) grabber → tracker(worker, YuNet) → latest FaceResult → solve_head_pose → MaskRenderer (quad projetado, textura de source-ref).
- **Fontes:** plugin-main · mask-filter (orquestra) · frame-grab · tracker · pose · mask-renderer (+ mask.effect). smoothing pendente (M4).
- **Build:** `cmake -S . -B build && cmake --build build -j && cmake --install build`.

---

## ⚠️ Pendências externas
- **Webcam WSL2:** WSLg não expõe USB cam. Testar com Media Source (vídeo) ou usbipd-win.
- **sudo** precisa senha → usuário roda apt. Deps já instaladas.

---

## 🔧 Comandos úteis

```bash
cd "/mnt/d/git-projeto/aye-aye-sir ( face tracking )"
cmake --build build -j && cmake --install build   # rebuild + instala
obs                                                # rodar (WSLg)
# teste isolado do YuNet: /tmp/ynt <model.onnx> <img.jpg>
```

---

## 📚 Referências
- `.wolf/cerebrum.md` — OBS gs API names, perspective-quad trick, head model, Do-Not-Repeat
- `.wolf/buglog.json` — bug-003: nomes de API OBS/OpenCV
- `~/.claude/plans/lively-exploring-brooks.md` — plano + milestones
