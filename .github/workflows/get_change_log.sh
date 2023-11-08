#!/usr/bin/env bash
tagName="${1:1}"
result=''
TRUE=0
FALSE=1
isTextLog="${FALSE}"
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "${isTextLog}" -eq "${TRUE}" ]]; then
    result="${result}${line}\n"
  fi
  if [[ "${line}" == "## ${tagName}" ]]; then
    isTextLog="${TRUE}"
    continue
  else
    if [[ "${line}" == "##"* ]]; then
      isTextLog="${FALSE}"
    fi
  fi
done < "CHANGELOG.md"

# 无限循环
while true; do
  if [[ ${result:${#result} - 2} == "\n" ]]; then
     result=${result:0:${#result} - 2}
  else
    break
  fi
done

echo -e "${result}"


