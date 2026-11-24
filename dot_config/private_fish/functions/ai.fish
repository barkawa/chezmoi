function ai --description 'Turn a natural-language request into a shell command'
    if test (count $argv) -eq 0
        echo 'Usage: ai <command description>' >&2
        return 2
    end

    if not set -q OPENAI_API_KEY; or test -z "$OPENAI_API_KEY"
        echo 'ai: OPENAI_API_KEY is not set' >&2
        return 1
    end

    set -l request (string join ' ' -- $argv)
    set -l distro
    if test -r /etc/os-release
        set distro (string match -r '^ID=.*' < /etc/os-release)
    end
    set -l instructions (string join \n -- \
        "Translate the user request into exactly one shell command for this Linux host. Distribution: $distro" \
        'The interactive shell is Fish. Account for the distribution when choosing package managers or system tools.' \
        'Output a brief explanation as shell comment lines beginning with #, followed by the command. Adapt the explanation length to the command complexity.' \
        'The explanation should include explanations of flags and syntax, using mnemonics where applicable.'\
        'The explanation must be well formatted and use short line-length (less than 80 chars ideally)'\
        'This is a terse command reference, not a teaching tool. Do not use Markdown fences, headings, bullets, or prose outside shell comments.' \
        'Never execute the command. If the command is destructive or otherwise risky, include a brief warning comment.')

    jq -cn \
        --arg instructions "$instructions" \
        --arg input "$request" \
        '{
                model: "gpt-5.6-terra",
                reasoning: {effort: "low"},
                store: false,
                instructions: $instructions,
                input: $input
            }' \
        | command curl --silent --show-error \
        https://api.openai.com/v1/responses \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        --data-binary @- \
        | jq -er '
            if .error then
                error("OpenAI API: " + .error.message)
            else
                [.output[]? | select(.type == "message") | .content[]? | select(.type == "output_text") | .text]
                | if length > 0 then join("\n") else error("OpenAI API returned no text output") end
            end
        '
    set -l pipeline_status $pipestatus

    return $pipeline_status[-1]
end
