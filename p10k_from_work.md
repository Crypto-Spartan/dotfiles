wizard options:
ascii, classic, dark, 24h time, 2 lines, dotted, sparse, concise, transient_prompt, instant_prompt=verbose

separation char is |

blanket color changes:
- any 76's to 77 (83 also good)
- 70 to 71
- 244 (& 246) to 248
- 178 to 184
- 37 (& 38) to 39
- 32 to 33
- 67 (& 68) to 69
- 34 to 35

- 96 to 97 ? <- check this one before doing it
- 66 to 72 ? <- check this one before doing it


left prompt elements:
- line 1
    - current dir -> anchors are gold, middle is green
    - vcs (git status) -> full: 'main >6 *1 !1 ?1' - green: 'main >6 *1', yellow: '!1', blue: '?1'
- line 2
    - newline
    - prompt_char (>)

right prompt elements:
- status -> SIGINT(2) in red
- command_execution_time -> gold
- background_jobs -> ?
- direnv
- asdf
- <bunch of envs>
- context (user@hostname) -> cyan-ish, slightly darker
- time -> pink-ish, slightly darker
- newline

- add empty newline before each prompt -> true

- multiline_first_prompt_gap_foreground = 240

- background = 235
- <LEFT & RIGHT>_SUBSEGMENT_SEPARATOR = '%248F|'

- PROMPT_CHAR_OK FOREGROUND = 41 (was 76)
- PROMPT_CHAR_ERROR FOREGROUND = 196

- DIR_FOREGROUND = 41 (was 31)
- SHORTEN_STRATEGY = truncate_to_unique
- DIR_SHORTENED_FOREGROUND = 98 (was 103)
- DIR_ANCHOR_FOREGROUND = 220 (was 39)

- comment out VCS_DISABLED_WORKDIR_PATTERN

- STATUS_VERBOSE_SIGNAME = true

- COMMAND_EXECUTION_TIME_THRESHOLD = 1
- COMMAND_EXECUTION_TIME_FOREGROUND = 220 (was 248)

- BACKGROUND_JOBS_VERBOSE = true
- BACKGROUND_JOBS_FOREGROUND = 39 (was 37)
- DIRENV_FOREGROUND = 184 (was 178)

- CONTEXT_ROOT_FOREGROUND = 197 (was 178)
- CONTEXT_<REMOTE>_FOREGROUND = 45 (was 180)
- CONTEXT_FOREGROUND = 45 (was 180)

- TRANSIENT_PROMPT = same-dir (commented out)

- INSTANT_PROMPT = verbose
