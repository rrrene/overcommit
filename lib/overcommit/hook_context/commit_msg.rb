module Overcommit::HookContext
  # Contains helpers related to contextual information used by commit-msg hooks.
  class CommitMsg < Base
    # User commit message stripped of comments and diff (from verbose output).
    def commit_message
      commit_message_lines.join
    end

    # Updates the commit message to the specified text.
    def update_commit_message(message)
      ::File.open(commit_message_file, 'w') do |file|
        file.write(message)
      end
    end

    def commit_message_lines
      raw_commit_message_lines.
        reject     { |line| line =~ /^#/ }.
        take_while { |line| !line.start_with?('diff --git') }
    end

    def commit_message_file
      @args[0]
    end

    private

    def raw_commit_message_lines
      ::IO.readlines(commit_message_file)
    end
  end
end
