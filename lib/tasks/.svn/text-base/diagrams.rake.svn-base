namespace :doc do
  namespace :diagram do
    task :models do
      sh "railroad -i -l -a -m -M | dot -Tsvg > doc/models.svg"
    end

    task :controllers do
      sh "railroad -i -l -C | neato -Tsvg > doc/controllers.svg"
    end
  end

  task :diagrams => %w(diagram:models diagram:controllers)
end