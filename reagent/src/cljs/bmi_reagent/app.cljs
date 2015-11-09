(ns bmi-reagent.app
  (:require [reagent.core :as r]))

(defonce bmi-data (r/atom {:height 180 :weight 80}))

(defn calc-bmi []
  "Calculate the body mass index for the given height and weight."
  (let [{:keys [height weight bmi] :as data} @bmi-data
        h (/ height 100)]  ;; Height in meters instead of centimeters.
    (if (nil? bmi)
      (assoc data :bmi (/ weight (* h h)))  ;; Set the BMI from the weight.
      (assoc data :weight (* bmi h h)))))  ;; Set the weight from the BMI.

(defn slider [param value min max]
  [:input {:type "range" :value value :min min :max max
           :style {:width "100%"}
           :on-change (fn [e]
                        (swap! bmi-data assoc param (.-target.value e))
                        ;; If we didn't move the bmi slider, recompute it from
                        ;; the height and weight values (see `if nil? bmi` in
                        ;; the `calc-bmi` function).
                        (when (not= param :bmi)
                          (swap! bmi-data assoc :bmi nil)))}])

(defn bmi-component []
  (let [{:keys [weight height bmi]} (calc-bmi)
        [color diagnostic] (cond
                          (< bmi 18.5) ["orange" "underweight"]
                          (< bmi 25) ["inherit" "normal"]
                          (< bmi 30) ["orange" "overweight"]
                          :else ["red" "obese"])]
    [:div
     [:div
      "Height: " (int height) "cm"
      [slider :height height 100 220]]
     [:div
      "Weight: " (int weight) "kg"
      [slider :weight weight 30 150]]
     [:div
      "BMI: " (int bmi) " "
      [:span {:style {:color color}} diagnostic]
      [slider :bmi bmi 10 50]]]))

(defn init []
  (r/render-component [bmi-component]
                      (.getElementById js/document "app")))
