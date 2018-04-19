 im = imread('/home/shreemoyee/Downloads/lenagray.jpg');
 pkg load image;
 im2= imnoise(im, 'speckle');
 [gx, gy] = gradient(double(im2));
 [gxx, gxy] = gradient(gx);
 [gxy, gyy] = gradient(gy);
 printf("starting!!");
 for i = 1:size(im2,1)
      for j = 1:size(im2,2)
         lam(i,j)=0.5*(gxx(i,j) + gxy(i,j) + sqrt((gxx(i,j)+gyy(i,j))^2 + 4*(gxy(i,j)^2)));
      end
   end
 mean_lam=mean(mean(lam))
 max_lam=max(max(lam)) 
 #mean_lam =  17.368
 printf("loop 1 done");
 for i = 1:size(im2,1)
      for j = 1:size(im2,2)
         lam2(i,j)=0.5*(gxx(i,j) + gxy(i,j) - sqrt((gxx(i,j)+gyy(i,j))^2 + 4*(gxy(i,j)^2)));
      end
   end
 ta=max_lam - mean_lam;
 tb=0.5*(max_lam + ta);
 printf("loop 2 done");
 for i = 1: size(im2,1)
       for j = 1:size(im2,2)
           if lam(i,j) < ta
              v(i,j)= -0.5;
           elseif (lam(i,j)<tb)  && (lam2(i,j)>ta)
              v(i,j) = -0.2;
           elseif (lam(i,j) >tb)
              v(i,j) = 0.5;


           end
        end
    end
 im3 = padarray(im2,[2,2],0,"both");
 v= padarray(v, [2,2] , 0,"both");
 printf("loop 3 done");
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
       res(i, j) = conv2( im3(i-2:i+2, j-2:j+2) , con, 'same')(3,3);
     end
    end
 printf("loop main done");
 im4=res(2:513, 2:513);
 im4=im4-min(im4(:));
 im4=im4/max(im4(:));
 imwrite(im4,'/home/shreemoyee/Downloads/proj_out2_new.jpg');
 printf("all done");
