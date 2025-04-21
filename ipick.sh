ipick() {
  local initial_dir=$(pwd)
  if [ $# -eq 0 ]; then
    cd "$initial_dir"
  else
    cd "$@"
  fi

  _ipick_inner() {
    local current_dir=$(pwd)

    local eza_command="eza -1A --icons=always --no-quotes --color=always | perl -pe 's/\s+\x1b\[[0-9;]*m->\x1b\[[0-9;]*m.*$//'"
    local file_list=$(eval "$eza_command")
    local combined_list=$(echo " ."; echo " .."; echo "$file_list";)

    local selected=$(echo "$combined_list" | fzf  \
      --info inline \
      --ansi \
      --exit-0 \
      --header="📂 $current_dir" \
      --header-first \
      --preview-window 'border-vertical' \
      --preview '
          if [[ {2..} == ".." ]]; then
            echo "[Enter = Go, Esc = Quit]"
            echo ""
            echo "$(tput bold)Directory: $(realpath ..)$(tput sgr0)"
            echo ""
            eza -1A --icons=always --no-quotes --color=always .. 
          elif [[ {2..} == "." ]]; then
            echo "[Enter = Pick, Esc = Quit]"
            echo ""
            echo "$(tput bold)Directory: $(pwd)$(tput sgr0)"
            echo ""
          elif [[ -d {2..} ]]; then
            echo "[Enter = Go, Esc = Quit]"
            echo ""
            echo "$(tput bold)Directory: {2..}$(tput sgr0)"
            echo ""
            eza -1A --icons=always --no-quotes --color=always {2..} 
          else
            echo -e "[Enter = Pick, Esc = Select]"
            echo ""
            echo "$(tput bold)File: {2..}$(tput sgr0)"
            echo ""
            echo "$(file --brief {2..})"
            echo ""
            item=$(echo {2..} | sed '"'"'s/\x1b\[[0-9;]*m//g'"'"')
            fzf-preview.sh "'"$current_dir"'/$item"
          fi
        '
      )

    if [[ -n "$selected" ]]; then
      local filename
      local trimmed="${selected:2}"
      filename=$(echo "$trimmed" | perl -pe 's/\x1B\[[0-9;]*[mK]//g')

      if [[ "$filename" == "." ]]; then
        full_path="$(pwd)"
        echo "$full_path"
        return
      elif [[ "$filename" == ".." ]]; then
        full_path="$(dirname "$(pwd)")"
      else
        full_path="$(pwd)/$filename"
      fi
      
      if [[ -L "$full_path" ]]; then
        local link_target=$(readlink "$full_path")
        
        if [[ ! "$link_target" == /* ]]; then
          link_target="$(dirname "$full_path")/$link_target"
        fi
        
        if [[ -d "$link_target" ]]; then
          cd "$link_target" && _ipick_inner
          return
        fi
      fi
      
      if [[ -d "$full_path" ]]; then
        cd "$full_path" && _ipick_inner
      else
        echo "$full_path"
      fi
    fi
  }

  _ipick_inner
  
  cd "$initial_dir"
}
