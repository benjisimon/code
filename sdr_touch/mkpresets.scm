;;
;; Generate a SDRTouchPresets.xml file from our local DB
;;

(load (cmd-dir "utils.scm"))


(define (make-presets frequency-file xml-file)
  (with-output-to-file xml-file
    (lambda ()
      (with-data-from-file frequency-file
       (lambda (data)
	 (show "<?xml version='1.0' encoding='UTF-8'?>")
	 (show "<sdr_presets version='1'>")
	 (for-each (lambda (category)
		     (show "<category id='" (gen-id) "' name='" (car category) "'>")
		     (for-each (lambda (preset)
				 (show "<preset id='" (gen-id) "' ")
				 (show "        name='" (cadr preset) "' ")
				 (show "        freq='" (freqval (car preset)) "' ")
				 (show "        centfreq='" (freqval (car preset)) "' ")
				 (show "        offset='0'")
				 (show "        order='" (gen-id) "' ")
				 (show "        filter='10508' ")
				 (show "        dem='1' ")
				 (show "/>"))
			       (cdr category))
		     (show "</category>"))
		   data)
	 (show "</sdr_presets>"))))))
  

(cond
 ((= 1 (length (cmd-args)))
  (make-presets (car (cmd-args)) "SDRTouchPresets.xml"))
 ((= 2 (length (cmd-args)))
  (make-presets (car (cmd-args)) (cadr (cmd-args))))
 (else
  (show "Need to provide frequency and output file to continue.")))
