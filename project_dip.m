 im = imread('C:\Users\H P\Downloads\lena.tif');
 %pkg load image;
 im2= imnoise(im, 'speckle');
 im2a=im2;
 %imshow(im2a);
 im2=uint8(log(double(im2)+1));
 [gx, gy] = gradient(double(im2a));
 [gxx, gyx] = gradient(gx);
 [gxy, gyy] = gradient(gy);
 for i = 1:size(im2a,1)
      for j = 1:size(im2a,2)
         lam(i,j)=0.5*(gxx(i,j) + gxy(i,j) + sqrt((gxx(i,j)+gyy(i,j))^2 + 4*(gxy(i,j)^2)));
      end
 end
 mean_lam=mean(mean(lam))
 max_lam=max(max(lam)) 
 fprintf('start2');
 
 for i = 1:size(im2a,1)
      for j = 1:size(im2a,2)
         lam2(i,j)=0.5*(gxx(i,j) + gxy(i,j) - sqrt((gxx(i,j)+gyy(i,j))^2 + 4*(gxy(i,j)^2)));
      end
 end
 ta=max_lam - mean_lam;
 tb=0.5*(max_lam + ta);
 fprintf('start2');
 for i = 1: size(im2a,1)
       for j = 1:size(im2a,2)
           if lam(i,j) < ta
              v(i,j)= -0.5;
           elseif (lam(i,j)<tb)  && (lam2(i,j)>ta)
              v(i,j) = -0.2;
           elseif (lam(i,j) >tb)
              v(i,j) = 0.5;
           end
        end
 end
 im3 = padarray(im2a,[2,2],0,'both');
 v= padarray(v, [2,2] , 0,'both');
 
 for i = 3: size(v,1)-2
    for j = 3: size(v,2)-2
       a=v(i,j);
       b=((a^2)-a)*0.5;
       con=zeros(5,5);
       con(1,1)=b;
       con(1,3)=b;
       con(1,5)=b;
       con(3,1)=b;

       con(5,1)=b;
       con(2,2)=-a;
       con(2,3)=-a;
       con(2,4)=-a;
       con(3,2)=-a;
       con(3,3)= 8;
       con(3,4)= -a;
       con(3,5)=b;
       con(4,2)=-a;
       con(4,3)=-a;
       con(4,4)=-a;
       con(5,3)=b;
       con(5,5)=b;
       temp=conv2( double(im3(i-2:i+2, j-2:j+2)) ,double(con), 'same');
       res(i, j) = temp(3,3);
     end
 end
 z=size(res,2);
 im4=res(2:z-1, 2:z-1);
 im5=im4;
 
 im4a=uint8(exp(double(im4))-1);
 im4=im4-min(im4(:));
 im4=im4/max(im4(:));
 subplot(1,3,1),imshow(im);
 subplot(1,3,2),imshow(im2a);
 subplot(1,3,3),imshow(im4);
 %imshow(im4);
 
 mse1=immse(im2uint8(im), im2uint8(im2a));
 fprintf('"MSE BETWEEN ORIGINAL AND NOISED IMAGE IS %0.4f\n ', mse1);
 psnr1 = 10*log10(255^2/mse1);
 fprintf('"psnr BETWEEN ORIGINAL AND NOISED IMAGE IS %0.4f\n"', psnr1);
 mse=immse(im2uint8(im), im2uint8(im4));
 
 fprintf('"MSE BETWEEN ORIGINAL AND DENOISED IMAGE IS %0.4f\n ', mse);
 psnr = 10*log10(255^2/mse);
 fprintf('"psnr BETWEEN ORIGINAL AND DENOISED IMAGE IS %0.4f\n"', psnr);
