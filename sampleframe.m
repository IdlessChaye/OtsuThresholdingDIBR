Path = './source4/';
SavePath = './images/';
File = dir(fullfile(Path, '*.jpg'));
FileNames = {File.name};
Length_Names = size(FileNames, 2);
count = 0;
number = 0;
for k = 1 : Length_Names
    count = count + 1;
    if count == 3
        count = 0;
        file_name = FileNames(k);
        A = imread([Path, file_name{1}]);
        imwrite(A, [SavePath, num2str(number), '.jpg']);
        number = number + 1;
    end
end
