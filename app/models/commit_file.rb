class CommitFile < ApplicationRecord
  belongs_to :commit

enum :change_type,
{
  added: 0,
  modified: 1,
  deleted: 2,
  renamed: 3
}
end
