module Overcommit::Hook::CommitMsg
  # Ensures the number of columns the subject and commit message lines occupy is
  # under the preferred limits.
  class TextWidth < Base
    def run
      @errors = []

      find_errors_in_subject(commit_message_lines.first)
      find_errors_in_body(commit_message_lines)

      return :warn, @errors.join("\n") if @errors.any?

      :pass
    end

    private

    def find_errors_in_subject(subject)
      max_subject_width = config['max_subject_width']
      return unless subject.length > max_subject_width

      @errors << "Please keep the subject <= #{max_subject_width} characters"
    end

    def find_errors_in_body(lines)
      return unless lines.count > 2

      max_body_width = config['max_body_width']

      lines[2..-1].each_with_index do |line, index|
        if line.chomp.size > max_body_width
          @errors << "Line #{index + 3} of commit message has > " \
                    "#{max_body_width} characters"
        end
      end
    end
  end
end
